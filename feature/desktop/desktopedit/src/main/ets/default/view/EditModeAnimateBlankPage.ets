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

import { LogDomain, LogHelper, SingleContext } from '@ohos/basicutils';
import {
  StyleConstants,
  EditModeUtils,
  LayoutViewModel,
  editModeManager
} from '@ohos/launchercommon';
import { EditModeStyleConfig } from '@ohos/launchercommon/src/main/ets/editmode/data/PageEditData';
import { EditModeGridSwiperViewData } from '../data/EditModeGridSwiperViewData';
import {
  EditModeBlankPageViewParams,
  editModeViewManager,
} from '../manager/EditModeViewManager';
import { EditModeSingePageViewData } from '../data/EditModeSingePageViewData';
import { PageEditViewModel } from '@ohos/launchercommon/Index';
import lazy OuterEditConstants from '../common/constants/OuterEditConstants';

const TAG: string = 'EditModeAnimateBlankPage';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

//扩展新形态小折叠产品 systemUI高度未适配临时方案
const EXPANDING_FOLD_SYSTEM_UI_TOP_HEIGHT = 24.75;

/**
 * 编辑模式新增空白页动效组件
 */
@Component
export struct EditModeAnimateBlankPage {
  @Prop singleContext?: SingleContext;
  private scaleCenterY: number = EditModeUtils.getScaleCenterY();
  private isOuterDesktop: boolean = false;
  private sysUITopHeight: number = LayoutViewModel.getInstance(this.singleContext).getSysUITopHeight();
  @State editModeGridSwiperViewData: EditModeGridSwiperViewData = editModeViewManager.getEditModeGridSwiperViewData();
  @State editModeSingePageViewData: EditModeSingePageViewData = editModeViewManager.getEditModeSingePageViewData();
  private desktopScale: number =
    this.editModeGridSwiperViewData.getGridSwiperScale() ? this.editModeGridSwiperViewData.getGridSwiperScale() : 1;
  private swiperScale: number = this.editModeSingePageViewData.getSingePageSwiperScale();
  private blankPageViewParams: EditModeBlankPageViewParams = new EditModeBlankPageViewParams();
  private bgTranslateY = this.editModeSingePageViewData.getEditModeBgTranslateY();
  private editModeStyleConfig: EditModeStyleConfig = editModeManager.getEditModeStyleConfig();
  private bgBottomToSwiperBottom: number = PageEditViewModel.getInstance().getEditModeBackGroundBottomDistanceY(
    this.editModeSingePageViewData.getEditModeBgTranslateY(),
    this.editModeGridSwiperViewData.getGridSwiperScale()
  );
  private buttonTranslateY =
    (this.bgBottomToSwiperBottom - this.editModeStyleConfig.pageEditDeleteIconMarginBottom) / this.desktopScale;

  aboutToAppear(): void {
    this.blankPageViewParams = editModeViewManager.getBlankPageViewParams(false);
  }

  @Styles
  pageEditButtonBgStyle() {
    .width(this.blankPageViewParams.buttonSize / this.desktopScale)
    .height(this.blankPageViewParams.buttonSize / this.desktopScale)
    .borderRadius((this.blankPageViewParams.buttonSize / this.desktopScale) / 2)
    .backgroundColor(
      editModeViewManager.isDarkWallPaper() ?
      this.editModeStyleConfig.pageEditButtonDarkBgColor :
      this.editModeStyleConfig.pageEditButtonBgColor
    )
    .hoverEffect(HoverEffect.None)
    .opacity(editModeViewManager.isDarkWallPaper() ? this.editModeStyleConfig.pageEditButtonDeepBgOpacity : 1)
  }

  build() {
    Stack() {
      Stack() {
        Row() {
        }
        .width(this.blankPageViewParams.bgWidth)
        .height(this.blankPageViewParams.bgHeight)
        .translate({y: this.bgTranslateY})
        .backgroundColor(this.editModeStyleConfig.pageEditBgColor)
        .opacity(this.editModeSingePageViewData.getSingePageBackgroundOpacity())
        .saturate(this.editModeSingePageViewData.getSingePageBackgroundSaturate())
        .borderRadius(this.blankPageViewParams.bgBorderRadius)
      }
      .scale({
        x: this.swiperScale,
        y: this.swiperScale,
        centerX: StyleConstants.PERCENTAGE_50,
        centerY: StyleConstants.PERCENTAGE_50,
      })
      Stack() {
        Row() {
        }
        .pageEditButtonBgStyle()
        Text() {
          SymbolSpan($r('sys.symbol.xmark'))
            .fontSize(`${this.blankPageViewParams.iconSize / this.desktopScale}vp`)
            .fontWeight(FontWeight.Normal)
            .renderingStrategy(SymbolRenderingStrategy.SINGLE)
            .fontColor([Color.White])
        }
      }
      .translate({
        y: this.buttonTranslateY
      })
    }
    .align(Alignment.Bottom)
    .position({
      x: 0,
      y: 0
    })
    .width((AppStorage.get<number>('screenWidth') as number) - 2 * this.editModeGridSwiperViewData.getPrevNextMargin())
    .scale({
      x: this.desktopScale,
      y: this.desktopScale,
      centerX: StyleConstants.PERCENTAGE_50,
      centerY: this.scaleCenterY,
    })
    .margin({
      top: this.sysUITopHeight,
      left: this.editModeGridSwiperViewData.getPrevNextMargin(),
      right: this.editModeGridSwiperViewData.getPrevNextMargin()
    })
  }
}