import { image } from "@kit.ImageKit";
import { LogUtil } from "@ohos/lottie";
import { Constants } from "../constants/wallpaperPathConstants";
import { ImageUtils } from "../utils/ImageUtils";
import { display, EditableLeftIconType, EditableTitleBar } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';
import UIExtensionContentSession from "@ohos.app.ability.UIExtensionContentSession";
import { ImageShowStyle } from "./ShowWallpaperPage";
import { CompleteImageAdapter } from "../utils/ImageFitProcessor";
import { Log } from "../aigcServiceAbility/IdlService/Log";

const TAG: string = 'WallpaperEditPage';

export enum WallPageType {
  WALLPAGETYPE_ALL,
  WALLPAGETYPE_DESKTOP,
  WALLPAGETYPE_LOCK
}

@Builder
export function WallpaperEditPageBuilder(name: string, param: Object) {
  WallpaperEditPage()
}

@Entry
@Component
export struct WallpaperEditPage {
  @Consume('pageInfos') pageInfos: NavPathStack;
  @State imageUrl: string = ''
  @State bgPixelMap?: image.PixelMap | null = null;
  @State hasPreView: boolean = false
  @State isSheetOpen: boolean = false
  @State wallpaperStyle: ImageShowStyle = ImageShowStyle.ImageShowStyleFullScreen
  setWallpaper?: (uri: string, imagePicelMap: image.PixelMap, wallpaperType: WallPageType) => Promise<boolean>;
  private context = getContext(this) as common.UIAbilityContext;

  async aboutToAppear(): Promise<void> {
    let session: UIExtensionContentSession | undefined = AppStorage.get('wallpaperSession')
    session?.sendData({ "thumbnailSuccess": true });
    session?.sendData({ "imageComplete": true });
    const wallpaperParams: Array<ESObject> = this.pageInfos.getParamByName(Constants.WALLPAPER_EDITOR) as Array<ESObject>;
    if (wallpaperParams.length > 0) {
      let param: ESObject = wallpaperParams[0];
      this.imageUrl = param['url'];
      Log.info(TAG, `aboutToappear---params----${this.imageUrl}`);
      this.bgPixelMap = await ImageUtils.convertUriToPixelMap(this.imageUrl);
    }
  }

  back() {
    try {
      // 核心：结束当前Ability，系统自动切回发起拉起的应用
      if (this.hasPreView === false) {
        this.context.terminateSelf((err: Error) => {
          if (err) {
            Log.error(TAG, 'ReturnApp');
          } else {
            Log.info(TAG, TAG, 'ReturnApp');
          }
        });
      } else {
        this.pageInfos.pop()
      }
    } catch (e) {
      Log.error(TAG, 'ReturnApp');
    }
  }

  getImageFit() {
    let imageFit: ImageFit = ImageFit.None
    switch (this.wallpaperStyle) {
      case ImageShowStyle.ImageShowStyleFullScreen:
        imageFit = ImageFit.Cover
        break;
      case ImageShowStyle.ImageShowStyleFitScreen:
        imageFit = ImageFit.Contain
        break;
      case ImageShowStyle.ImageShowStyleCenterScreen:
        imageFit = ImageFit.None
        break;
      case ImageShowStyle.ImageShowStyleStretchScreen:
        imageFit = ImageFit.Fill
        break;
      case ImageShowStyle.ImageShowStyleTileScreen:
        imageFit = ImageFit.None
        break;

      default:
        break;
    }
    return imageFit
  }

  @Builder
  navBuilder() {
    Row() {
      // 壁纸标题
      EditableTitleBar({
        leftIconStyle: EditableLeftIconType.Back,
        title: '',
        menuItems: [],
        onCancel: () => {
          this.back()
        },
        isSaveIconRequired: false
      }).backgroundColor(Color.Transparent)
    }
    .backgroundColor(Color.Transparent)
  }

  @Styles
  navButtonStyle() {
    .constraintSize({minWidth: 100, minHeight: 40})
    .height(40)
    .backgroundColor(Color.White)
    .borderRadius(20)
    .opacity(0.6)
}

  @Builder
  sheetContent() {
    Column() {
      // 选项1
      Row() {
        Text($r('app.string.set_wallpaper_lock'))
          .fontSize(16)
          .fontColor($r('sys.color.font_primary'))
          .maxLines(1)
          .textOverflow({
            overflow: TextOverflow.Ellipsis
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .height(56)
      .padding({ left: 16, right: 16 })
      .onClick(async () => {
        this.isSheetOpen = false
        if (this.setWallpaper) {
          this.setWallpaper(this.imageUrl, this.bgPixelMap!, WallPageType.WALLPAGETYPE_LOCK).then((isBack: boolean) => {
            if (isBack) {
              this.back()
            }
          })
        }
      })

      Divider()
        .color($r('sys.color.comp_divider'))
        .width('95%')
      // 选项2
      Row() {
        Text($r('app.string.set_wallpaper_desktop'))
          .fontSize(16)
          .fontColor($r('sys.color.font_primary'))
          .maxLines(1)
          .textOverflow({
            overflow: TextOverflow.Ellipsis
          })

      }
      .width('100%')
      .height(56)
      .justifyContent(FlexAlign.Center)
      .padding({ left: 16, right: 16 })
      .onClick(() => {
        this.isSheetOpen = false
        if (this.setWallpaper) {

          this.setWallpaper(this.imageUrl, this.bgPixelMap!, WallPageType.WALLPAGETYPE_DESKTOP).then((isBack: boolean) => {
            if (isBack) {
              this.back()
            }
          })
        }
      })
      Divider()
        .color($r('sys.color.comp_divider'))
        .width('95%')

      // 选项2
      Row() {
        Text($r('app.string.set_wallpaper_all'))
          .fontSize(16)
          .fontColor($r('sys.color.font_primary'))
          .maxLines(1)
          .textOverflow({
            overflow: TextOverflow.Ellipsis
          })

      }
      .width('100%')
      .height(56)
      .justifyContent(FlexAlign.Center)
      .padding({ left: 16, right: 16 })
      .onClick(() => {
        this.isSheetOpen = false
        if (this.setWallpaper) {
          this.setWallpaper(this.imageUrl, this.bgPixelMap!, WallPageType.WALLPAGETYPE_ALL).then((isBack: boolean) => {
            if (isBack) {
              this.back()
            }
          })
        }
      })
      Divider()
        .color($r('sys.color.comp_divider'))
        .width('95%')

      // 取消按钮
      Button($r('app.string.cancle'))
        .width('100%')
        .height(48)
        .fontSize(16)
        .fontColor($r('sys.color.warning'))
        .backgroundColor($r('sys.color.comp_background_list_card'))
        .margin({ top: 8, left: 16, right: 16, bottom: 16 })
        .onClick(() => {
          this.isSheetOpen = false
        })
    }
    .width('100%')
    .justifyContent(FlexAlign.Center)
    .backgroundColor($r('sys.color.comp_background_list_card'))
  }

  build() {
    NavDestination() {
     Stack() {
       Image(this.bgPixelMap)
         .width('100%')
         .height('100%')
          Row() {
         Button($r('app.string.cancle'))
           .navButtonStyle()
           .fontColor(Color.Black)
           .position({ left: 16 })
           .onClick(() => {
             this.back()
           })

         Button($r('app.string.wallpaper_editor'))
           .navButtonStyle()
           .fontColor(Color.Black)
           .position({ right: 16 })
           .onClick(() => {
             this.isSheetOpen = true
           })
       }
       .width('100%')
       .justifyContent(FlexAlign.SpaceBetween)
       .margin({ top: 30 })
     }
     .width('100%')
      .height('100%')
      .alignContent(Alignment.TopStart)
    }
    .width('100%')
    .hideTitleBar(true)
    .bindSheet(
      this.isSheetOpen,
      this.sheetContent(),
      {
        dragBar: true,
        showClose: false,
        height: 247,
        onDisappear: () => {
          this.isSheetOpen = false
        }
      }
    )
    .backgroundImageSize(ImageSize.Cover)
  }
}