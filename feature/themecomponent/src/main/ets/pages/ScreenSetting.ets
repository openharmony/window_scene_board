@Component
export struct ScreenSetting {
  backAction?: () => void

  private onReceiveSCBData: (data: object) => void = (data: object) => {
    if (data && data['action'] !== undefined) {
        this.backAction?.()
    }
  }

  build() {
    NavDestination() {
      UIExtensionComponent({
        bundleName: 'com.ohos.sceneboard',
        abilityName: 'DesktopSettingUIExtAbility',
        parameters: {
          'ability.want.params.uiExtensionType': 'sys/commonUI',
          'nav': 'setting',
          'isFull': true,
        }
      })
        .width('100%')
        .height('100%')
        .onError((error) => {
          // LogUtil.info(`${TAG} UIExtensionComponent onError code: ${error?.code} message: ${error?.message}`);
          // this.viewModel.refreshing(error, this.recoverController, BUNDLE_NAME, ABILITY_NAME);
        })
        .onTerminated(() => {
        })
        .onReceive(this.onReceiveSCBData)
        .id('wallpaper_picker_extension')
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM, SafeAreaEdge.TOP])
    }
    .width('100%')
    .height('100%')
    .hideTitleBar(true)
    .backgroundColor($r('sys.color.ohos_id_color_titlebar_sub_bg'))
    .onShown(() => {
      // this.onPageShow();
    })
    .onHidden(() => {
      // this.onPageHide();
    })
    .padding({
      top: 24
      // left: this.observedData.left, right: this.observedData.right
    })
  }
}