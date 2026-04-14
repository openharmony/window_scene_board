/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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
import { picker } from '@kit.CoreFileKit';
import { Log } from '../aigcServiceAbility/IdlService/Log';


const TAG: string = 'ShowWallpaperPage';
const CELL_WIDTH = 108
const CELL_HEIGHT = 192
@Builder
export function ShowWallpaperPageBuilder(name: string, param: Object) {
  ShowWallpaperPage()
}

@Entry
@Component
export struct ShowWallpaperPage {
  selectImageFromGallery?: () => void;
  pickWallpaperToEdit?: (imageUrl: Resource) => void;
  @State categories: ThemeCategory[] = [];//本地壁纸可以在这里加上
  @State selectedWallpaperId: string = '1';
  private pageStack: NavPathStack = new NavPathStack();
  // 每个分组的滚动控制器
  private scrollerMap: Map<string, Scroller> = new Map();
  private uiContext: common.UIAbilityContext = getContext() as common.UIAbilityContext;
  private context = getContext(this) as common.UIAbilityContext;

  aboutToAppear(): void {
    Log.info(TAG, 'aboutTo appear')
  }

  @Builder
  navBuilder() {
    Row() {
      // 壁纸标题
      EditableTitleBar({
        leftIconStyle: EditableLeftIconType.Back,
        title: $r('app.string.edit_wallpaper'),
        menuItems: [],
        onCancel: () => {
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
        .fontColor($r('sys.color.black'))
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
    .backgroundColor(Color.White)
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
          .fontColor($r('sys.color.black'))
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
    Scroll() {
      Column() {
        //我的壁纸
        this.currentWallpaperBuilder()
        // 遍历所有分类
        ForEach(this.categories, (category: ThemeCategory, index: number) => {
          this.ThemeCategory(category);
        }, (category: ThemeCategory, index: number) => `${index}_${category.title}`);
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Start)
      .padding({
        left: 16,
        right: 16,
        top: 12,
        bottom: 12
      });
    }
    .width('100%')
    .layoutWeight(1)
    .scrollable(ScrollDirection.Vertical)
    .scrollBar(BarState.Off)
    .edgeEffect(EdgeEffect.Spring);
  }

  /**
   * 主题分类组件
   */
  @Builder
  ThemeCategory(category: ThemeCategory) {
    Column() {
      // 分类标题
      Text(category.title)
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('sys.color.font_primary'))
        .width('100%')
        .margin({ bottom: 12 });

      // 水平滚动容器
      Scroll(this.scrollerMap.get(category.title)) {
        Row({ space: 12 }) {
          // 渲染该分类下的所有壁纸卡片
          ForEach(category.wallpapers, (wallpaper: WallpaperCard) => {
            this.WallpaperCard(wallpaper);
          }, (wallpaper: WallpaperCard) => wallpaper.id);
        }
        .padding({ right: 8 })
        .width('100%')
        .justifyContent(FlexAlign.Start)
      }
      .scrollable(ScrollDirection.Horizontal)
      .scrollBar(BarState.Off)
      .width('100%')
      .height(192)
      .edgeEffect(EdgeEffect.Spring);
    }
    .width('100%')
    .margin({ bottom: 24 });
  }

  /**
   * 壁纸卡片组件
   */
  @Builder
  WallpaperCard(wallpaper: WallpaperCard) {
    Stack() {
      // 壁纸图片
      Image($r('app.media.test_wallpaper')) //这里先用占位图
      // Image(wallpaper.imageUrl)
        .width(108)
        .height(192)
        .borderRadius(12)
        .objectFit(ImageFit.Cover)
        .border({
          width: wallpaper.id === this.selectedWallpaperId ? 2 : 0,
          color: '#0A59F7'
        })
        .onClick(() => { //在壁纸页面选择图片进入编辑页面
          this.pickWallpaperToEdit ? this.pickWallpaperToEdit($r('app.media.test_wallpaper')) : "";
          this.selectedWallpaperId = wallpaper.id;
          Log.info(TAG, 'ScrollableGalleryPage', `选中壁纸: ${wallpaper.id}`);
        })
        .onError((error) => {
          Log.error(TAG, 'ScrollableGalleryPage', `图片加载失败: ${error}`);
        });

      // 选中状态标记
      if (wallpaper.id === this.selectedWallpaperId) {
        // 右下角选中标记
        Stack() {
          Circle()
            .width(24)
            .height(24)
            .fill('#0A59F7')
            .position({ x: 84, y: 168 });

          Image($r('sys.media.ohos_ic_public_ok'))
            .width(14)
            .height(14)
            .fillColor('#FFFFFF')
            .position({ x: 89, y: 173 });
        }
      }
    }
    .width(CELL_WIDTH)
    .height(CELL_HEIGHT);
  }

  build() {
    NavDestination() {
      Column() {
        this.navBuilder()
        //从图库中选择
        this.photosBuilder()
        //整体管理
        this.wallPageBuild()
      }
      .width('100%')
      .height('100%')
      .backgroundColor($r('sys.color.ohos_id_color_titlebar_sub_bg'))
    }
  }
}

interface WallpaperCard {
  id: string; // 壁纸唯一标识
  imageUrl: string | Resource; // 壁纸图片URL
  isSelected?: boolean; // 是否选中状态
}

interface ThemeCategory {
  title: string; // 分组标题
  wallpapers: WallpaperCard[]; // 该分组下的壁纸列表
}