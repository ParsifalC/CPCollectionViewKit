#
# CPCollectionViewKit.podspec
#
# Be sure to run `pod lib lint CPCollectionViewKit.podspec` to ensure this is a
# valid spec before submitting.
#
# See http://guides.cocoapods.org/syntax/podspec.html for reference.
#

Pod::Spec.new do |s|
  s.name             = 'CPCollectionViewKit'
  s.version          = '1.0.0'
  s.summary          = 'A collection of creative UICollectionView layouts for iOS.'

  s.description      = <<-DESC
CPCollectionViewKit provides a suite of highly customizable UICollectionView layout
subclasses, including:

- CardLayout      — Scrollable cards with fade, scale, and 3D rotation effects
- CaterpillarLayout — Items arranged along a circular arc like a caterpillar
- CircleLayout    — Items distributed on a full circle arc
- StageLayout     — One featured "on-stage" item with side items queuing up
- TimeMachineLayout — Stacked deck of cards with depth scaling
- WheelLayout     — Items arranged around a wheel at 8 anchor positions
- TransitionLayout — Smooth animated transitions between any two layouts
                       DESC

  s.homepage         = 'https://github.com/ParsifalC/CPCollectionViewKit'
  s.screenshots      = 'https://github.com/ParsifalC/CPCollectionViewKit/raw/master/Demos/CPCollectionViewCardLayoutDemo/CardLayoutZoominout.gif',
                       'https://github.com/ParsifalC/CPCollectionViewKit/raw/master/Demos/CPCollectionViewWheelLayoutSwiftDemo/WheelLayoutLeftBottom.gif'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Parsifal' => 'zmw@izmw.me' }
  s.source           = { :git => 'https://github.com/ParsifalC/CPCollectionViewKit.git', :tag => s.version.to_s }

  s.ios.deployment_target = '14.0'
  s.swift_versions        = ['5.0', '5.1', '5.5', '5.10']

  s.source_files = 'CPCollectionViewKit/*.swift'
  s.frameworks   = 'UIKit'
end
