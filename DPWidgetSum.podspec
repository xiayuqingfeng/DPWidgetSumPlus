Pod::Spec.new do |s|

s.name          = 'DPWidgetSum'
s.version       = '2.6.4'
s.ios.deployment_target = '8.0'
s.summary       = 'A delightful setting interface framework.'
s.homepage      = 'https://github.com/xiayuqingfeng/DPWidgetSum'
s.license       = { :type => 'MIT', :file => 'LICENSE' }
s.author        = { '江湖两两把刀' => 'xia18101310780@163.com' }
s.source        = { :git => 'https://github.com/xiayuqingfeng/DPWidgetSum.git', :tag => s.version }
s.source_files  = 'DPWidgetSum_SDK/Classes/**/*.{h,m}'
s.resource_bundles = { 'DPWidgetSumBubdle' => ['DPWidgetSum_SDK/Assets/DPResources.bundle'] }
s.requires_arc  = true
s.frameworks    = 'UIKit','Foundation'

# 加载进度
s.dependency 'MBProgressHUD'
# 响应链
s.dependency 'ReactiveObjC', '~> 3.1.1'
# 富文本label
s.dependency 'TTTAttributedLabel', '~> 2.0.0'
# 图片下载
s.dependency 'SDWebImage','3.8.2'
# JS桥接文件
s.dependency 'WebViewJavascriptBridge', '~> 6.0.3'
# SBJson解析
s.dependency 'SBJson', '~> 5.0.0'
# 网络请求
s.dependency 'AFNetworking'
# UM
s.dependency 'UMCommon'
s.dependency 'UMDevice'
s.dependency 'UMAPM'
# U-Share SDK UI模块（分享面板，建议添加）
s.dependency 'UMShare/UI'
s.dependency 'UMShare'
# 集成微信(完整版14.4M)
s.dependency 'UMShare/Social/WeChat'
end
