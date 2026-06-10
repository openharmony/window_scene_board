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

import { image } from "@kit.ImageKit";
import { LogUtil } from "@ohos/lottie";
import { Constants } from "../constants/wallpaperPathConstants";
import { ImageUtils } from "../utils/ImageUtils";
import { EditableLeftIconType, EditableTitleBar } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';
import UIExtensionContentSession from "@ohos.app.ability.UIExtensionContentSession";

const TAG: string = 'WallpaperEditPage';

@Builder
export function WallpaperEditPageBuilder(name: string, param: Object) {
  WallpaperEditPage()
}

@Entry
@Component
export struct WallpaperEditPage {
  @Consume('pageInfos') pageInfos: NavPathStack;
  @State imageUrl: string = ''
  @State bgPixelMap?: image.PixelMap | Resource | null = null;
  @State hasPreView: boolean = false
  setWallpaper?: (uri: string) => void;
  private context = getContext(this) as common.UIAbilityContext;

  async aboutToAppear(): Promise<void> {
    let session: UIExtensionContentSession | undefined = AppStorage.get('wallpaperSession')
    session?.sendData({ "thumbnailSuccess": true });
    session?.sendData({ "imageComplete": true });
    const wallpaperParams: Array<ESObject> = this.pageInfos.getParamByName(Constants.WALLPAPER_EDITOR) as Array<ESObject>;
    if (wallpaperParams.length > 0) {
      let param: ESObject = wallpaperParams[0];
      this.imageUrl = param['url'];
      this.bgPixelMap = await ImageUtils.convertUriToPixelMap(this.imageUrl)
    }
    LogUtil.info(`aboutToappear---params----${JSON.stringify(wallpaperParams)}`)
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
          try {
            // 核心：结束当前Ability，系统自动切回发起拉起的应用
            if (this.hasPreView === false) {
              this.context.terminateSelf((err: Error) => {
                if (err) {
                  LogUtil.error(TAG, 'ReturnApp');
                } else {
                  LogUtil.info(TAG, 'ReturnApp');
                }
              });
            } else {
              this.pageInfos.pop()
            }
          } catch (e) {
            LogUtil.error(TAG, 'ReturnApp');
          }
        },
        isSaveIconRequired: false
      }).backgroundColor(Color.Transparent)
    }
    .backgroundColor(Color.Transparent)
  }

  build() {
    NavDestination() {
      Column() {
        this.navBuilder()

        Button($r('app.string.wallpaper_editor'))
          .width(100)
          .height(40)
          .backgroundColor(Color.White)
          .fontColor(Color.Black)
          .borderRadius(20)
          .opacity(0.8)
          .position({ right: 15 })
          .onClick(() => {
            if (this.setWallpaper) {
              this.setWallpaper(this.imageUrl)
            }

          })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(HorizontalAlign.Center)
      .margin({ top: 30 })
    }
    .hideTitleBar(true)
    .backgroundImage(this.bgPixelMap)
    .backgroundImageSize(ImageSize.Cover)
  }
}