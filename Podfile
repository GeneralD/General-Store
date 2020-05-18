platform :osx, '10.15'

target 'General Store' do
	use_frameworks!
	
	pod 'RxSwift'
	pod 'RxCocoa'
	pod 'RxOptional'
	pod 'RxViewController'
	pod 'RxAlamofire'
	pod 'Moya/RxSwift'
	pod 'RxNSCollectionView', :git => 'https://github.com/GeneralD/RxNSCollectionView'
	
	target 'General StoreTests' do
		inherit! :search_paths
		pod 'Quick'
		pod 'RxNimble'
	end
end
