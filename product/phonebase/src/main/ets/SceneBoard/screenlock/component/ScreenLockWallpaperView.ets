import Want from "@ohos.app.ability.Want"
import { DesktopManager } from "@ohos/launchercommon"

@Component
export struct ScreenLockWallpaperView {
  hiddenWallpaperView?: ()=>void
  @Prop want: Want
  private onReceiveSCBData: (data: object) => void = (data: object) => {
    if (data && data['hiddenLockWallpaper'] !== undefined) {
      if (this.hiddenWallpaperView) {
        this.hiddenWallpaperView?.()
      }
    }
  }
  build() {
    Column(){
      Column()
        .width('100%')
        .layoutWeight(1)
        .onClick(() => {
          if (this.hiddenWallpaperView) {
            this.hiddenWallpaperView?.()
          }
        })
      UIExtensionComponent({
        bundleName: 'com.ohos.sceneboard',
        abilityName: 'HomeThemeComponentExtAbility',
        parameters: {
          'ability.want.params.uiExtensionType': 'sys/commonUI',
          'nav': 'wallpaperPicker',
          'isFull': false,
          'isHybird': true,//新增一个参数，是否是半模态
          // 'desktopParam': DesktopManager.getInstance().updateParam().updateExtendParam().getDesktopParam(),
        }
      })
        .width('100%')
        .height('90%')
        .onDisAppear(() => {
        })
        .onTerminated(() => {
        })
        .onReceive(this.onReceiveSCBData)
        .id('wallpaper_picker_extension')
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM, SafeAreaEdge.TOP])
    }

    .hitTestBehavior(HitTestMode.None)
    .justifyContent(FlexAlign.End)
    .backgroundColor('#33000000')
      .width('100%')
      .height('100%')
  }
}