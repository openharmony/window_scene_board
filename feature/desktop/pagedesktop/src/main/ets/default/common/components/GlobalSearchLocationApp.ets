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

import { AppIconCommonView, AppIconConfig } from '@ohos/launchercommon/Index';
import { PageDesktopViewModel } from '../viewmodel/PageDesktopViewModel';
import { PageDesktopGridStyleConfig } from '@ohos/launchercommon/src/main/ets/layoutconfig/PageDesktopGridStyleConfig';
import { CheckEmptyUtils, LogDomain, LogHelper, RectInfo, SingleContext, Trace } from '@ohos/basicutils';
import { ItemUtils } from '@ohos/componenthelper';
import GlobalSearchLocationParam from '../viewmodel/GlobalSearchLocationParam';
import Curves from '@ohos.curves';
import { AppNameVm } from '@ohos/launchercommon/src/main/ets/launchericon/viewmodel/AppNameVm';
import { OpenFolderStyleConfig, SmartDockZoomFeatureSwitch } from '@ohos/launchercommon';
import lazy { SmartDockZoomManager }from '@ohos/launchercommon/src/main/ets/dock/common/SmartDockZoomManager';
import { SearchLocationType } from '@ohos/launchercommon/src/main/ets/constants/CommonConstants';

const TAG = 'GlobalSearchLocationApp';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

@Component
export default struct GlobalSearchLocationApp {
  @Prop singleContext?: SingleContext;
  private gsParam: GlobalSearchLocationParam = new GlobalSearchLocationParam();
  private pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
  private styleConfig: PageDesktopGridStyleConfig = this.pageDesktopViewModel.getPageDesktopStyleConfig();
  private rect: RectInfo = new RectInfo();
  @State animateScaleX: number = 1;
  @State animateScaleY: number = 1;
  private animationFinish: number = 4;
  @State blurScale: number = 0;
  private appNameVmIndesktop: AppNameVm = new AppNameVm();
  private appNameVmInFolder: AppNameVm = new AppNameVm();
  @State iconSize:number = this.styleConfig.mIconSize;
  private appIconConfig: AppIconConfig = new AppIconConfig();


  aboutToAppear(): void {
    this.appIconConfig.setEnableName(false)
      .setIsDesktopItem(false)
      .setEnableMenu(false)
      .setEnableDrag(false)
      .setEnableMultiSelect(false);
    log.showInfo(`rectName = ${this.gsParam.rectName}`);
    this.rect = ItemUtils.getRectById(this.gsParam.rectName);
    log.showInfo(`this.rect.width = ${this.rect.width}, this.rect.heigth = ${this.rect.height},` +
      `this.rect.left = ${this.rect.left}, this.rect.top = ${this.rect.top}`);
    this.animationFinish = 4;
    // 全搜定位到dock栏应用且需要缩放的话，通过SmartDockZoomManager获取图标缩放系数
    this.iconSize = PageDesktopViewModel.getInstance(this.singleContext).getPageDesktopStyleConfig().mIconSize;
    if (this.gsParam.type === SearchLocationType.DOCK_TYPE && SmartDockZoomFeatureSwitch.isSupportZoom()) {
      this.iconSize *= SmartDockZoomManager.getDockScale();
    }
    this.locationAnimationFirstStage();
    this.locationBackgroundShow();
    this.appNameVmIndesktop.modifier.onInit = (instance?: CommonAttribute) => {
      instance
      ?.width('165%')
        .align(Alignment.Center)
    };

    this.appNameVmInFolder.modifier.onInit = (instance?: CommonAttribute) => {
      instance
      ?.width(OpenFolderStyleConfig.getInstance().getOpenFolderStyle().gridItemWidth)
    };
  }

  aboutToDisappear(): void {
  }

  private locationBackgroundShow() {
    animateTo({
      duration: 250,
      curve: Curves.cubicBezierCurve(0.33, 0, 0.67, 1),
      onFinish: () => {
        Trace.end('backgroundShow');
      }
    }, () => {
      this.blurScale = 1;
      Trace.start('backgroundShow');

    })
  }

  private locationBackgroundFade() {
    animateTo({
      duration: 250,
      curve: Curves.cubicBezierCurve(0.33, 0, 0.67, 1),
      onFinish: () => {
        log.showInfo(`locationBackgroundFade, onFinish`);
        Trace.end('backgroundFade');
      }
    }, () => {
      Trace.start('backgroundFade');
      this.blurScale = 0;
    })
  }

  private locationAnimationFirstStage() {
    animateTo({
      duration: 150,
      curve: Curves.cubicBezierCurve(0.3, 0, 0.4, 1),
      onFinish: () => {
        Trace.end('locationAnimationFirstStage');
        this.locationAnimation();
      }
    }, () => {
      Trace.start('locationAnimationFirstStage');
      this.animateScaleY = 0.9;
      this.animateScaleX = 0.9;
    })
  }

  private locationAnimation() {
    animateTo({
      duration: 300,
      curve: Curves.cubicBezierCurve(0.3, 0, 0.3, 1),
      onFinish: () => {
        this.animationFinish--;
        if (this.animationFinish !== 0) {
          this.locationAnimation();
        } else {
          Trace.end('locationAnimation');
          this.locationBackgroundFade();
        }
      }
    }, () => {
      if (this.animationFinish == 4) {
        Trace.start('locationAnimation');
        this.animateScaleY = 1.15;
        this.animateScaleX = 1.15;
      }
      if (this.animationFinish == 3) {
        this.animateScaleY = 1;
        this.animateScaleX = 1;
      }
      if (this.animationFinish == 2) {
        this.animateScaleY = 1.15;
        this.animateScaleX = 1.15;
      }
      if (this.animationFinish == 1) {
        this.animateScaleY = 1;
        this.animateScaleX = 1;
      }
    })
  }

  @Builder
  appIconDesktop() {
    AppIconCommonView({
      appNameVm: this.appNameVmIndesktop,
      iconSize: this.iconSize,
      iconRadius: this.styleConfig.mIconRadius,
      nameHeight: this.styleConfig.mNameHeight,
      nameWidth: this.styleConfig.mNameWidth,
      nameSize: this.styleConfig.mNameSize,
      nameMarginTop: this.styleConfig.mIconNameMargin + this.styleConfig.mIconNameMarginTop,
      nameFontColor: this.styleConfig.mNameFontColor,
      item: this.gsParam.appItem,
      maxNameLines: 1
    })
  }

  @Builder
  appIconDock() {
    AppIconCommonView({
      appIconConfig: this.appIconConfig,
      iconSize: this.iconSize,
      iconRadius: this.styleConfig.mIconRadius,
      item: this.gsParam.appItem
    })
  }

  @Builder
  appIconFolder() {
    AppIconCommonView({
      appNameVm: this.appNameVmInFolder,
      iconSize: this.iconSize,
      iconRadius: this.styleConfig.mIconRadius,
      nameHeight: this.styleConfig.mNameHeight,
      nameWidth: this.styleConfig.mNameWidth,
      nameSize: this.styleConfig.mNameSize,
      nameMarginTop: OpenFolderStyleConfig.getInstance().getOpenFolderStyle().appNameMarginTop,
      nameFontColor: this.styleConfig.mNameFontColor,
      item: this.gsParam.appItem,
      isFolderAppName: true,
      maxNameLines: 1
    })
  }

  build() {
    Stack() {
      Column()
        .width('100%')
        .height('100%')
        .backgroundBlurStyle(BlurStyle.BACKGROUND_THIN, {
          scale: this.blurScale,
          policy: 1
        }, { disableSystemAdaptation: true })
        .id(`${TAG}_Column_container`)
      Column() {
        if (this.gsParam.type === SearchLocationType.DESKTOP_ITEM) {
          this.appIconDesktop();
        } else if (this.gsParam.type === SearchLocationType.DOCK_TYPE) {
          this.appIconDock();
        } else if (this.gsParam.type === SearchLocationType.BIG_FOLDER_ITEM_TYPE ||
          this.gsParam.type === SearchLocationType.SMALL_FOLDER_ITEM_TYPE ||
          this.gsParam.type === SearchLocationType.DOCK_FOLDER_ITEM_TYPE) {
          this.appIconFolder();
        }
      }
      .scale({
        x: this.animateScaleX,
        y: this.animateScaleY
      })
      .width(this.rect.width)
      .height(this.rect.height)
      .position({
        x: this.rect.left,
        y: this.rect.top,
      })
    }
    .width('100%')
    .height('100%')
    .hitTestBehavior(HitTestMode.Block)
    .id(`${TAG}_Stack_container1`)
  }
}