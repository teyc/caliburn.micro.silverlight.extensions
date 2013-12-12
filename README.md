Caliburn.Micro.Silverlight.Extensions
=======================================

Purpose
=======

This library integrates Caliburn.Micro and
Silverlight Navigation so that you can do
ViewModel-first development.

Sample Code
===========

Here is a taste of how navigation is performed:

    public class HomePageViewModel {

      public INavigationService NavigationService { get; set; }

      void LinkClicked() {

        // Navigates to "/Views/SettingsView?SettingId=19"
        NavigationService.UriFor<SettingsViewModel>().WithParam<int>(()=>SettingId, 19).Navigate();

      }
    }

Setting up
===========

Navigation in Silverlight is performed by a Frame control. We 
adapt a Frame control to support Caliburn.Micro's INavigationService
interface using a FrameAdapter.

This adaptation can be done once the frame is loaded. For example,
after the call to `DisplyRootViewFor<IShell>`.

Here's a sample bootstrapper. When the ShellView has been displayed,
we register the Frame control in the ShellView as a singleton.
When Caliburn.Micro needs to inject a NavigationService, it will 
construct/fetch a singleton instance of FrameAdapter (which implements
INavigationService).

	using System;
	using System.Collections.Generic;
	using Caliburn.Micro;

	public class AppBootstrapper : BootstrapperBase
	{
		SimpleContainer container;

		public AppBootstrapper()
		{
			Start();
		}

		protected override void Configure()
		{
			container = new SimpleContainer();

			container.Singleton<IWindowManager, WindowManager>();
			container.Singleton<IEventAggregator, EventAggregator>();
            container.Singleton<IShell, ShellViewModel>();
            container.Singleton<ShellView, ShellView>();
            container.Singleton<INavigationService, FrameAdapter>();

		}

		protected override object GetInstance(Type service, string key)
		{
			var instance = container.GetInstance(service, key);
			if (instance != null)
				return instance;

			throw new InvalidOperationException("Could not locate any instances.");
		}

		protected override IEnumerable<object> GetAllInstances(Type service)
		{
			return container.GetAllInstances(service);
		}

		protected override void BuildUp(object instance)
		{
			container.BuildUp(instance);
		}

		protected override void OnStartup(object sender, System.Windows.StartupEventArgs e)
		{
			DisplayRootViewFor<IShell>();

            // finds the Frame control in the ShellView, 
            // registers it, and then reinitialize the shell
            var frame = FrameAdapter.FindFrame(App.Current.RootVisual, null);
            container.RegisterInstance(typeof(System.Windows.Controls.Frame), null, frame);

            BuildUp((App.Current.RootVisual as System.Windows.Controls.UserControl).DataContext);
		}
	}
   


