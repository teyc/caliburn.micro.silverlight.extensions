/*
   Silverlight Navigation Extensions for Caliburn.Micro
   
   Here is a sample file for you to get started quickly.
   Note that you must register FrameAdapter with the bootstrapper
   or else this will not work.

   Firstly, right click on your Silverlight Project, 
   select Properties and change the Startup object to
   "$rootnamespace$.NavigationAppSample".
  
   Next, make sure your MainPage.xaml contains a Frame
   control.

   Start adding Pages and ViewModels to your project.
   Then, you can navigate to each page in your MainViewModel
   like this.

   public class MainViewModel
   {
        // 1. Create Views/PageOne.xaml 
        // 2. Create Views/PageOneViewModel.cs
        // 3. Add public int QuestionId {get; set;} to PageOneViewModel
        // 4. Add a HyperLinkButton called x:Name="GotoPageOne" on MainPage.xaml
        public void GotoPageOne()
        {
            // Navigates to /Views/PageOne?QuestionId=42
            NavigationService.UriFor<PageOneViewModel>().WithParam((vm)=>vm.QuestionId, 42).Navigate();
        }
   }
*/   
   
namespace $rootnamespace$ 
{
    using Caliburn.Micro;
    using System;
    using System.Windows;
    using System.Windows.Controls;

    public class NavigationBootstrapperSample : BootstrapperBase, ILog
    {
        private SimpleContainer container = new SimpleContainer();

        public NavigationBootstrapperSample()
        {
            Start();
        }

        protected override void Configure()
        {

            // Important! All ViewModels must be registered
            // container.RegisterPerRequest(typeof(MainViewModel), null, typeof(MainViewModel));

            // Maps MainPageViewModel to MainPage
            ViewLocator.NameTransformer.AddRule(@"ViewModel$", @"Page");

            // Maps e.g. /Views/PageOneViewModel.cs to /Views/PageOne.xaml
            ViewLocator.NameTransformer.AddRule(@"ViewModel$", String.Empty);

            // Reverse maps /Views/PageOne.xaml to /Views/PageOneViewModel.cs
            ViewModelLocator.NameTransformer.AddRule(@"$", @"ViewModel");

            LogManager.GetLog = (type) => this;

        }

        protected override void OnStartup(object sender, StartupEventArgs e)
        {
            DisplayRootViewFor<MainViewModel>();

            // Sets up DI to inject INavigationService
            var rootVisual = App.Current.RootVisual as UserControl;
            var frame = rootVisual.FindFrame();
            if (frame == null)
            {
                throw new InvalidOperationException(String.Format(
                    "NavigationExtensions require '{0}' to have a Frame control",
                    rootVisual.GetType()));
            }
            container.RegisterInstance(typeof(Frame), null, frame);
            container.RegisterSingleton(typeof(INavigationService), null, typeof(FrameAdapter));
            this.BuildUp(rootVisual.DataContext);

            // Navigate to the home page
            //((INavigationService) this.GetInstance(typeof(INavigationService), null)).UriFor<HomeViewModel>().Navigate();

        }

        #region IoC

        // Caliburn.Micro's IoC is hooked into BootstrapperBase
        // the following overrides allow IoC to use the container
        // provided
        protected override object GetInstance(Type service, string key)
        {
            return container.GetInstance(service, key);
        }

        protected override void BuildUp(object instance)
        {
            container.BuildUp(instance);
        }

        protected override System.Collections.Generic.IEnumerable<object> GetAllInstances(Type service)
        {
            return container.GetAllInstances(service);
        }

        #endregion

        #region ILog

        public void Error(Exception exception)
        {
            System.Diagnostics.Debug.WriteLine(exception.Message);
        }

        public void Info(string format, params object[] args)
        {
            System.Diagnostics.Debug.WriteLine(format, args);
        }

        public void Warn(string format, params object[] args)
        {
            System.Diagnostics.Debugger.Break();
            System.Diagnostics.Debug.WriteLine(format, args);
        }

        #endregion
    }
    
    public class NavigationAppSample : Application
    {
        public NavigationAppSample()
        {
            this.Resources.Add("bootstrapper", new NavigationBootstrapperSample());
        }
    }

    public class MainViewModel
    {
        public INavigationService NavigationService { get; set; }

        //// 1. Create Views/PageOne.xaml 
        //// 2. Create Views/PageOneViewModel.cs
        //// 3. Add public int QuestionId {get; set;} to PageOneViewModel
        //// 4. Add a HyperLinkButton called x:Name="GotoPageOne" on MainPage.xaml
        //public void GotoPageOne()
        //{
        //    // Navigates to /Views/PageOne?QuestionId=42
        //    NavigationService.UriFor<PageOneViewModel>().WithParam((vm)=>vm.QuestionId, 42).Navigate();
        //}

    }


}

