namespace Caliburn.Micro
{
    using System.Collections.Generic;
    using System.Linq;
    using System.Windows;
    using System.Windows.Controls;

    internal static class LinqExtensions
    {
        public static IEnumerable<UIElement> Descendants(this UIElement e)
        {
            if (e is Panel)
            {
                Panel p = e as Panel;
                foreach (UIElement c in p.Children)
                {
                    yield return c;
                }

                foreach (UIElement c in p.Children.SelectMany(d => d.Descendants()))
                {
                    yield return c;
                }
            }
            else if (e is UserControl)
            {
                UserControl u = e as UserControl;
                yield return u;

                foreach (var c in (u.Content as UIElement).Descendants())
                {
                    yield return c;
                }
            }
            else if (e is Border)
            {
                yield return e;
                yield return (e as Border).Child as UIElement;
            }
            else if (e is ContentControl)
            {
                yield return e;
                yield return (e as ContentControl).Content as UIElement;
            }
            else
            {
                yield return e;
            }
        }
    }
}
