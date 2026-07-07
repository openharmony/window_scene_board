/*
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { EditableLeftIconType, EditableTitleBar } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';
import { Log } from '../aigcServiceAbility/IdlService/Log';
import { ImageUtils } from '../utils/ImageUtils';
import { WallpaperCell } from './WallpaperCell';
import { Constants } from '../constants/wallpaperPathConstants';
import { LogUtil } from '@ohos/lottie';
import { commonEventManager } from '@kit.BasicServicesKit';


const TAG: string = 'ShowWallpaperPage';
const CELL_WIDTH = 108
const CELL_HEIGHT = 192
const MY_NAME = 'app.string.current_wallpaper'

export enum ImageShowStyle {
  ImageShowStyleFullScreen = 0, //充满屏幕,
  ImageShowStyleFitScreen = 1, //适合屏幕0
  ImageShowStyleCenterScreen = 2, //居中显示
  ImageShowStyleStretchScreen = 3, //拉伸铺满
  ImageShowStyleTileScreen = 4 //平铺
}

const menuArr: Array<string | Resource> = [$r('app.string.screen_full'),$r('app.string.screen_fit'),
  $r('app.string.screen_center'), $r('app.string.screen_sctetch'), $r('app.string.screen_tile')]

@Builder
export function ShowWallpaperPageBuilder(name: string, param: Object) {
  ShowWallpaperPage()
}

@Entry
@Component
export struct ShowWallpaperPage {
  selectImageFromGallery?: () => void;
  pickWallpaperToEdit?: (imageUrl: string, wallpaperStyle: ImageShowStyle) => void;
  pushScreenSettingPage?: () => void
  clickClose?: () => void
  @State categories: ThemeCategory[] = [
    new ThemeCategory(MY_NAME, [])
  ];//本地壁纸可以在这里加上
  @State selectedWallpaperId: string = '1';
  private pageStack: NavPathStack = new NavPathStack();
  // 每个分组的滚动控制器
  private scrollerMap: Map<string, Scroller> = new Map();
  private uiContext: common.UIAbilityContext = getContext() as common.UIAbilityContext;
  private context = getContext(this) as common.UIAbilityContext;
  private refreshWallpaperSubscriber: commonEventManager.CommonEventSubscriber | undefined = undefined
  @State myImageList: string[] = []
  @State refreshFlag: boolean = false
  @StorageLink(Constants.LOCAL_WALLPAPER) localWallpaper: string = ''
  @State wallpapers: WallpaperCard[] = []
  @State currentImageStyle: ImageShowStyle = ImageShowStyle.ImageShowStyleFullScreen
  @State isShowStyleMenu: boolean = false
  @State currentValue: string | Resource = menuArr[0]
  @State currentIndex: number = 0
  @State currentPage: boolean = false
  @State autoIsOn: boolean = false

  async aboutToAppear(): Promise<void> {
    Log.info(TAG, 'aboutTo appear')
    this.currentPage = true
    this.getMyImageList()
    this.subscribeRefreshWallpaperEvent();
    this.subscribeCrossProcessEvent('ts.event.theme.close')
  }

  async subscribeRefreshWallpaperEvent(): Promise<void> {
    try {
      const subscribeInfo: commonEventManager.CommonEventSubscribeInfo = {
        events: [Constants.REFRESH_WALLPAPER],
        priority: 100,
      };
      this.refreshWallpaperSubscriber = await commonEventManager.createSubscriber(subscribeInfo);
      await new Promise<void>(async (resolve, reject) => {
        commonEventManager.subscribe(this.refreshWallpaperSubscriber!, async (error, data) => {
          if (error) {
            Log.error(TAG, `subscribe refresh wallpaper failed
                            name:${error?.name} message:${error?.message} stack:${error?.stack}`);
            reject(error);
          } else {
            this.getMyImageList()
            resolve();
          }
        });
      });
      Log.info(TAG, `subscribe refresh wallpaper success`);
    } catch (error) {
      let err = error as BusinessError;
      Log.error(TAG, `subscribe refresh wallpaper error:
                      name:${err?.name} message:${err?.message} stack:${err?.stack}`);
    }
  }

  //订阅消息
  async subscribeCrossProcessEvent(eventName: string): Promise<void> {
    try {
      // 创建订阅者信息
      const subscribeInfo: commonEventManager.CommonEventSubscribeInfo = {
        events: [eventName],
        priority: 100,
      };
      // 创建订阅者
      let subscriber = await commonEventManager.createSubscriber(subscribeInfo);
      // 订阅事件
      await new Promise<void>(async (resolve, reject) => {
        commonEventManager.subscribe(subscriber, async (error, data) => {
          if (error) {
            LogUtil.error(TAG, `subscribe failed: ${JSON.stringify(error)}`);
            reject(error);
          } else {
            const eventTimestamp = data?.parameters!['timestamp'] as number;
            const currentTime = Date.now()
            if ((currentTime - eventTimestamp < 100) && (this.currentPage === true)) {
              this.closeWallpaper()
            }
            resolve();
          }
        });
      });

      LogUtil.info( `subscribe success: ${eventName}`);
    } catch (error) {
      LogUtil.error(`error: ${JSON.stringify(error)}`);
    }
  }

  aboutToDisappear(): void {
    this.currentPage = false;
    if (this.refreshWallpaperSubscriber) {
      commonEventManager.unsubscribe(this.refreshWallpaperSubscriber, (error) => {
        if (error) {
          Log.error(TAG, `unsubscribe refresh wallpaper failed
                          name:${error?.name} message:${error?.message} stack:${error?.stack}`);
        } else {
          Log.info(TAG, `unsubscribe refresh wallpaper success`);
        }
      });
      this.refreshWallpaperSubscriber = undefined;
    }
  }
  async getMyImageList() {
    let localPath = await ImageUtils.saveResourceToSandbox(this.context)
    const jsonPath = await ImageUtils.initJsonFile(this.context)
    const dataList = await ImageUtils.readJsonFile(jsonPath)
    if (!dataList.includes(localPath)) {
      await ImageUtils.addData(jsonPath, dataList, localPath)
    }
    //获取默认图片并插入
    let wallpapers: WallpaperCard[] = []
    this.myImageList = await ImageUtils.readJsonFile(jsonPath)

    this.myImageList.forEach((name: string, index: number) => {
      let isSelected = index === 0 ? true : false
      let card = this.wallpapers.find((item) => item.imageUrl === name) || new WallpaperCard(`${index}`, name, isSelected)
      card.id = `${index}`;
      card.isSelected = isSelected;
      wallpapers.push(card)
    })
    this.categories[0].wallpapers = wallpapers;
    this.wallpapers = wallpapers;
  }


  closeWallpaper() {
    try {
      // 核心：结束当前Ability，系统自动切回发起拉起的应用
      this.context.terminateSelf((err) => {
        if (err) {
          Log.error(TAG, 'ReturnApp');
        } else {
          Log.info(TAG, 'ReturnApp');
        }
      });
    } catch (e) {
      Log.error(TAG, 'ReturnApp');
    }
  }

  @Builder
  navBuilder() {
    Row() {
      // 壁纸标题
      EditableTitleBar({
        leftIconStyle: EditableLeftIconType.Back,
        title: $r('app.string.Desktop_individuation'),
        menuItems: [],
        onCancel: () => {
          if (this.clickClose) {
            this.clickClose?.()
          }
         this.closeWallpaper()
        },
        isSaveIconRequired: false
      }).backgroundColor($r('sys.color.ohos_id_color_titlebar_sub_bg'))
    }.width('100%')
    .margin({ top: 30 })
    .backgroundColor($r('sys.color.ohos_id_color_titlebar_sub_bg'))
  }

  @Builder
  photosBuilder() {
    Row() {
      Image($r("app.media.ohos_gallery_foreground"))
        .width(40)
        .height(40)
        .borderRadius(8)
      // 中间文字
      Text($r('app.string.theme_chose'))
        .fontSize(16)
        .fontColor($r('sys.color.font_primary'))
        .padding({
          left: 20
        })
        .layoutWeight(1) // 让文字占据剩余空间
      // 右侧箭头
      Image($r("app.media.ic_settings_arrow"))
        .width(20)
        .height(20)
    }
    .padding({
      left: 16,
      right: 16,
      top: 12,
      bottom: 12
    })
    .borderRadius(12)
    .width('95%')
    .margin({ top: 10 })
    .backgroundColor($r('sys.color.comp_background_list_card'))
    .onClick(() => {
      if (this.selectImageFromGallery) {
        this.selectImageFromGallery();
      }
    })
  }

  @Builder
  currentWallpaperBuilder() {
    Column() {
      Row() {
        // 左侧标题
        Text($r('app.string.current_wallpaper'))
          .fontSize(18)
          .fontColor($r('sys.color.font_primary'))
          .fontWeight(FontWeight.Medium)

        // 右侧管理按钮
        // Text($r('app.string.managment'))
        Text('')
          .fontSize(16)
          .fontColor(Color.Blue)
          .padding({ left: 16, right: 16 })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)

      Row() {
        Image($r('app.media.icon_myWallpaper'))
          .width(CELL_WIDTH)
          .height(CELL_HEIGHT)
          .borderRadius(16).margin({ top: 12, bottom: 24 })
      }.width('100%')
      .justifyContent(FlexAlign.Start)
    }
    .margin({
      top: 24
    })
  }

  @Builder
  wallPageBuild() {
    Column() {
      //我的壁纸
      // this.currentWallpaperBuilder()
      // 遍历所有分类
      // ForEach(this.categories, (category: ThemeCategory, index: number) => {
        this.ThemeCategory();
      // }, (category: ThemeCategory, index: number) => `${index}_${category.title}`);

      //下方新增一个自动对齐功能
      this.showAutoAlignBuilder()
    }
    .width('100%')
    .justifyContent(FlexAlign.Start)
    .padding({
      left: 16,
      right: 16,
      top: 12,
      bottom: 12
    });
  }

  /**
   * 主题分类组件
   */
  @Builder
  ThemeCategory() {
    Column() {
      // 分类标题
      Text($r('app.string.current_wallpaper'))
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('sys.color.font_primary'))
        .width('100%')
        .margin({ bottom: 12 });

      // 水平滚动容器
      Scroll(this.scrollerMap.get('current_wallpaper')) {
        Row({ space: 12 }) {
          // 渲染该分类下的所有壁纸卡片
          ForEach(this.wallpapers, (wallpaper: WallpaperCard) => {
            WallpaperCell({
              wallpaper: wallpaper,
              selectWallpaperImage: (wallpaper: WallpaperCard) => {
                this.pickWallpaperToEdit ? this.pickWallpaperToEdit(wallpaper.imageUrl, this.currentImageStyle) : "";
              }
            })
          }, (wallpaper: WallpaperCard) => `${wallpaper.id}_${wallpaper.imageUrl}`);
        }
        .padding({ right: 8 })
        .justifyContent(FlexAlign.Start)
      }
      .scrollable(ScrollDirection.Horizontal)
      .scrollBar(BarState.Off)
      .width('100%')
      .height(192)
      .edgeEffect(EdgeEffect.Spring)
      .align(Alignment.Start)

      //新增模式显示
      Divider()
        .height(1)
        .backgroundColor($r('sys.color.ohos_id_color_titlebar_sub_bg'))
        .width('100%')
        .margin({
          top: 12,
        })

      Row() {
        Text($r('app.string.wallpaper_show_style'))
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor($r('sys.color.font_primary'))
          .maxLines(2)
          .textOverflow({
            overflow: TextOverflow.Ellipsis
          })
          .width('60%')


        Row() {
          Text(this.currentValue)
            .fontSize(14)
            .fontColor($r('sys.color.font_primary'))
            .maxLines(2)
            .textOverflow({
              overflow: TextOverflow.Ellipsis
            })
            // .wordBreak(WordBreak.BREAK_ALL)


          Image($r('app.media.ic_arrow_down_new'))
            .fillColor($r('sys.color.ohos_id_color_secondary'))
            .width(24)
            .height(24)
        }
        .width('35%')
        .justifyContent(FlexAlign.End)

      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(VerticalAlign.Center)
      .margin({
        top: 12
      })
      .onClick(() => {
        this.isShowStyleMenu = !this.isShowStyleMenu
      })
      .bindMenu(this.isShowStyleMenu, this.ShowStyleMenu, { placement: Placement.BottomRight })
    }
    .width('100%')
    .margin({ bottom: 24 })
    .backgroundColor($r('sys.color.comp_background_list_card'))
    .padding(16)
    .borderRadius(16)
  }

  @Builder
  ShowStyleMenu() {
    Column() {
      ForEach(menuArr, (value: string | Resource, index) => {
        WallpaperMenuItem({
          value: value,
          index: index,
          isSelected: this.currentIndex === index ? true : false,
          clickItem: (value: string | Resource, index: number) => {
            this.currentValue = value
            this.currentIndex = index
            this.isShowStyleMenu = false
            switch (index) {
              case 0:
                this.currentImageStyle = ImageShowStyle.ImageShowStyleFullScreen
                break;
              case 1:
                this.currentImageStyle = ImageShowStyle.ImageShowStyleFitScreen
                  break;
              case 2:
                this.currentImageStyle = ImageShowStyle.ImageShowStyleCenterScreen
                  break;
              case 3:
                this.currentImageStyle = ImageShowStyle.ImageShowStyleStretchScreen
                  break;
              case 4:
                this.currentImageStyle = ImageShowStyle.ImageShowStyleTileScreen
                  break;

              default:
                break;
            }
          }
        })
          .onDisAppear(() => {
            this.isShowStyleMenu = false
          })
        if (index !== menuArr.length - 1) {
          Line()
            .width('100%')
            .height(1)
            .backgroundColor($r('sys.color.ohos_id_color_titlebar_sub_bg'))
        }
      })
    }
    .width(150)
  }

  @Builder
  showAutoAlignBuilder() {
    Row() {
      Text($r('app.string.Desktop_setting'))
        .fontSize(16)
        .fontColor($r('sys.color.font_primary'))
        .padding({
          // left: 20
        })

      // 右侧箭头
      Image($r("app.media.ic_settings_arrow"))
        .width(20)
        .height(20)

    }
    .padding({
      top: 12,
      bottom: 12,
      left: 16,
      right: 16
    })
    .justifyContent(FlexAlign.SpaceBetween)
    .borderRadius(12)
    .width('100%')
    .margin({ top: 10 })
    .backgroundColor($r('sys.color.comp_background_list_card'))
    .onClick(() => {
      if (this.pushScreenSettingPage) {
        this.pushScreenSettingPage?.()
      }
    })
  }


  build() {
    NavDestination() {
      Column() {
        this.navBuilder()
        Scroll() {
          Column() {
            //从图库中选择
            this.photosBuilder()
            //整体管理
            this.wallPageBuild()
          }
          .width('100%')
          .constraintSize({
            minHeight: '100%'
          })
        }
        .width('100%')
        .layoutWeight(1)
        .align(Alignment.Top)
        .scrollable(ScrollDirection.Vertical)
        .scrollBar(BarState.Off)
        .edgeEffect(EdgeEffect.Spring)
      }
      .width('100%')
      .height('100%')
      .backgroundColor($r('sys.color.ohos_id_color_titlebar_sub_bg'))
    }
    .onShown(() => {
      this.currentPage = true
    })
    .onHidden(() => {
      this.currentPage = false
    })
  }
}

export class WallpaperCard {
  id: string; // 壁纸唯一标识
  imageUrl: string; // 壁纸图片URL
  isSelected?: boolean; // 是否选中状态
  pixelMap?: PixelMap;

  constructor(id: string, imageUrl: string, isSelected: boolean = false) {
    this.id = id;
    this.imageUrl = imageUrl
    this.isSelected = isSelected

    ImageUtils.readLocalImage(this.imageUrl).then((data: PixelMap | null) => {
      if (data) {
        this.pixelMap = data;
      }
      Log.info(TAG, `wallpaper1:${this.id} ${this.imageUrl} > ${this.pixelMap == null}`);
    }).catch((error: ESObject) => {
      Log.info(TAG, `wallpaper.imageUrl:${this.imageUrl} error: ${error}`);
    })
  }
}

@Observed
export class  ThemeCategory {
  title: string; // 分组标题
  wallpapers: WallpaperCard[]; // 该分组下的壁纸列表
  constructor(title: string, wallpapers: WallpaperCard[]) {
    this.title = title;
    this.wallpapers = wallpapers;
  }
}


@Component
struct WallpaperMenuItem {
  @Prop value: string | Resource
  @Prop index: number
  @Prop isSelected: boolean
  clickItem?: (value: string | Resource, index: number)=>void

  build() {
    Row() {
      Text(this.value)
        .fontSize(14)
        .fontColor(this.isSelected ? $r('sys.color.ohos_id_color_emphasize') : $r('sys.color.font_primary'))
        .maxLines(1)
        .textOverflow({
          overflow: TextOverflow.Ellipsis
        })
        .width('90%')
    }
    .margin({
      left: 8,
      right: 8
    })
    .borderRadius(8)
    .height(38)
    .width('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(VerticalAlign.Center)
    .onClick(() => {
      this.clickItem?.(this.value, this.index)
    })
  }

}
