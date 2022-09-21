# Uncomment the next line to define a global platform for your project
platform :ios, '15.4'

def rx
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RxDataSources'
  pod 'RxGesture'
  pod 'RxCoreLocation'
  pod "RxMKMapView"
  pod "RxAnimated"
end

def rx_test
  pod 'RxTest'
  pod 'RxBlocking'
end

def json
  pod 'SwiftyJSON'
end

def alamofire
  pod 'Alamofire'
end

def rswift
  pod 'R.swift'
end

def firebase
  pod 'FirebaseAuth'
  pod 'FirebaseFirestore'
  pod 'RxFirebase/Firestore'
  pod 'RxFirebase/RemoteConfig'
  pod 'RxFirebase/Database'
  pod 'RxFirebase/Storage'
  pod 'RxFirebase/Auth'
  pod 'CodableFirebase'
end

def facebook
  pod 'FacebookCore'
  pod 'FacebookLogin'
  pod 'FacebookShare'
end

def loader
  pod 'NVActivityIndicatorView'
end

def image
  pod 'Nuke'
end

target 'GrubChaser' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  firebase
  facebook
  loader
  rx
  json
  alamofire
  rswift
  image

  target 'GrubChaserTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'GrubChaserUITests' do
    # Pods for testing
  end

end
