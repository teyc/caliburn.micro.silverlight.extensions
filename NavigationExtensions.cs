namespace Caliburn.Micro {

    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Windows;
    using System.Windows.Controls;
    
    /// <summary>
    /// Extension methods related to navigation.
    /// </summary>
    public static class NavigationExtensions {
        /// <summary>
        /// Creates a Uri builder based on a view model type.
        /// </summary>
        /// <typeparam name="TViewModel">The type of the view model.</typeparam>
        /// <param name="navigationService">The navigation service.</param>
        /// <returns>The builder.</returns>
        public static UriBuilder<TViewModel> UriFor<TViewModel>(this INavigationService navigationService) {
            if (navigationService == null)
            {
                //navigationService = IoC.Get<INavigationService>(null);
            }
            if (navigationService == null)
            {
                throw new Exception("NavigationService must not be null");
            }
            
            return new UriBuilder<TViewModel>().AttachTo(navigationService);
        }

        /// <summary>
        /// Finds a Frame control in a UserControl
        /// </summary>
        /// <param name="fe">The parent element</param>
        /// <param name="name">Optional name of the frame if known</param>
        /// <returns></returns>
        public static Frame FindFrame(this UIElement fe, string name = null)
        {
            if (name != null)
            {
                return (from c in fe.Descendants()
                        where name.Equals(c.GetValue(FrameworkElement.NameProperty))
                             && c is Frame
                        select c).FirstOrDefault() as Frame;
            }
            else
            {
                return (from c in fe.Descendants()
                        where c is Frame
                        select c).FirstOrDefault() as Frame;
            }
        }

    }
}