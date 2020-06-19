---
layout: default
title: Extend UWP app views into titlebar
tags: windows uwp titlebar xaml c#
comments: true
---
# Extend UWP app views into titlebar

The following code, added to the constructor of your main page, can help extend your views into the titlebar region

```c#
ApplicationViewTitleBar titleBar = ApplicationView.GetForCurrentView().TitleBar;
titleBar.ButtonBackgroundColor = Colors.Transparent;
titleBar.ButtonInactiveBackgroundColor = Colors.Transparent;
CoreApplicationViewTitleBar coreTitleBar = CoreApplication.GetCurrentView().TitleBar;
coreTitleBar.ExtendViewIntoTitleBar = true;
```

It is a slightly modified version of the original code [available from StackOverflow](https://stackoverflow.com/questions/33440438/how-to-hide-collapse-title-bar-in-a-uwp-app). It makes the background of titlebar buttons transparent in the active state, and inactive state&mdash;when the window is out of focus. The titlebar region still allows you to use the mouse to drag the window around.

That may not be enough if you're using a `Microsoft.UI.Xaml.Controls.NavigationView` control from [`Microsoft.UI.Xaml`](https://github.com/microsoft/microsoft-ui-xaml/) version `2.4.2`. Although the menu itself extends into the titlebar, its content does not.

One workaround to make the content extend into the titlebar involves setting a negative top margin for the inner frame, like so

```xml
    </winui:NavigationView.MenuItems>
    <Frame x:Name="shellFrame" Margin="0, -32, 0, 0" />
</winui:NavigationView>
```

Another option is to set the [`IsTitleBarAutoPaddingEnabled`](https://docs.microsoft.com/en-us/uwp/api/microsoft.ui.xaml.controls.navigationview.istitlebarautopaddingenabled) property to `False`, but then the back button and hamburger menu button are overshadowed by the titlebar region, when they're located there due to a smaller window size, and cannot be clicked.
