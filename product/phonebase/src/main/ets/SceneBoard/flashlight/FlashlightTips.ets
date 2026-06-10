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

import { SCBScreenProperty } from '@ohos/windowscene';
import { BaseViewController } from '@ohos/frameworkcommon';
import { ViewType, viewMgrPolicy } from '@ohos/frameworkwrapper';
import { LogHelper, LogDomain, } from '@ohos/basicutils';
import { FlashlightTipsConstants } from '@ohos/screenlockcommon/src/main/ets/constants/FlashlightTipsConstants';
import { FlashlightTipsUtil } from '@ohos/screenlockcommon/src/main/ets/utils/FlashlightTipsUtil';
import { SmallFoldStyleUtil } from '@ohos/launchercommon/src/main/ets/utils/SmallFoldStyleUtil';
import {
  FlashlightTipsAnimationData,
  FlashlightTipsModel,
  FlashlightTipsWindowData
} from './model/FlashlightTipsModel';

const TAG = 'FlashlightTips';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

/**
 * 新形态小折叠外屏手电筒提示页
 */
@Component
export struct FlashlightTips {
  @Link screenProp: SCBScreenProperty;
  @State persistentId: number = 0;
  @State mAnimationData: FlashlightTipsAnimationData = new FlashlightTipsAnimationData();
  @State mWindowData: FlashlightTipsWindowData = new FlashlightTipsWindowData();
  private mFlashlightModel: FlashlightTipsModel = new FlashlightTipsModel();
  private viewController: BaseViewController = new BaseViewController(ViewType.FLASHLIGHT_TIPS);

  aboutToAppear(): void {
    log.showInfo(`aboutToAppear`);
    // 打开手电筒提示页打点
    FlashlightTipsUtil.flashlightTipsReport(FlashlightTipsConstants.PNAMEID
      , FlashlightTipsConstants.PVERSIONID, FlashlightTipsConstants.OPEN_FLASHLIGHT_TIPS_EVENT);

    viewMgrPolicy.registerViewController(ViewType.FLASHLIGHT_TIPS, this.viewController);
    this.viewController.updateId(this.persistentId);
    this.viewController.show();
    this.mWindowData.viewController = this.viewController;
    this.mWindowData.screenProp = this.screenProp;
    this.mFlashlightModel.setData(this.mAnimationData, this.mWindowData);
    this.mFlashlightModel.registerListeners();
  }

  aboutToDisappear(): void {
    log.showInfo(`aboutToDisappear`);
    // 解注册事件
    viewMgrPolicy.unregisterViewController(ViewType.FLASHLIGHT_TIPS);
    this.mFlashlightModel.unRegisterListeners();
  }

  /**
   * 手电筒翻转提示页面
   */
  @Builder
  private FlipTipsPage(): void {
    Stack() {
      ImageAnimator()
        .images(this.mAnimationData.images)
        .draggable(false)
        .state(AnimationStatus.Running)
        .width('100%')
        .height('100%')
        .iterations(-1)
      this.FlipTipsText();
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  private FlipTipsText() {
    RelativeContainer() {
      Text(this.mAnimationData.tipsText)
        .opacity(this.mAnimationData.tipsTextOneOpacity)
        .width(FlashlightTipsConstants.UI_TIPS_TEXT_MAX_WIDTH)
        .fontSize(FlashlightTipsConstants.UI_TIPS_TEXT_FONT_SIZE)
        .maxFontScale(SmallFoldStyleUtil.NORMAL_FONT_SIZE_SCALE)
        .fontColor(Color.White)
        .fontWeight(FontWeight.Medium)
        .textAlign(TextAlign.Center)
        .alignRules({
          middle: { anchor: '__container__', align: HorizontalAlign.Center },
          top: { anchor: '__container__', align: VerticalAlign.Center },
          bottom: { anchor: '__container__', align: VerticalAlign.Bottom }
        })
    }
    .height('auto')
    .offset({ y: FlashlightTipsConstants.TIPS_TEXT_CONTAINER_OFFSET })
  }

  /**
   * 手电筒退出页面
   */
  @Builder
  private FlipTipsQuitPage(): void {
    RelativeContainer() {
      Image($r('app.media.ic_flashlight_open'))
        .width(FlashlightTipsConstants.UI_QUIT_IMAGE_WIDTH)
        .height(FlashlightTipsConstants.UI_QUIT_IMAGE_HEIGHT)
        .draggable(false)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
    }
    .width(FlashlightTipsConstants.UI_QUIT_BUTTON_WIDTH)
    .height(FlashlightTipsConstants.UI_QUIT_BUTTON_HEIGHT)
    .alignRules({
      center: { anchor: '__container__', align: VerticalAlign.Center },
      middle: { anchor: '__container__', align: HorizontalAlign.Center }
    })
    .backgroundColor($r('app.color.Control_center_icon_on_bg_color'))
    .borderRadius('100%')
    .clip(true)
    .onClick((event) => {
      // 点击按钮退出页面打点
      FlashlightTipsUtil.flashlightTipsReport(FlashlightTipsConstants.PNAMEID,
        FlashlightTipsConstants.PVERSIONID, FlashlightTipsConstants.CLOSE_FLASHLIGHT_BY_BUTTON_EVENT);
      // 退出页面
      this.mFlashlightModel.exitPage(false, false);
    })
  }

  /**
   * 监听上滑退出组件
   */
  @Builder
  private slideUpGestureComponent(): void {
    // 监听上滑手势
    Text()
      .width('100%')
      .height('5%')
      .alignRules({bottom: {anchor: `__container__`, align: VerticalAlign.Bottom}})
      .onTouch(event => {
        if (event.type === TouchType.Down) {
          this.mAnimationData.quitMoveY = event.changedTouches[0].y;
        }
        if (event.type === TouchType.Up &&
          (this.mAnimationData.quitMoveY -
            event.changedTouches[0].y >= FlashlightTipsConstants.QUIT_GESTURE_THRESHOLD)) {
          this.mFlashlightModel.exitPage(true, false);
        }
      })
  }

  build() {
    RelativeContainer() {
      if (this.mWindowData.showClosePage) {
        this.FlipTipsQuitPage();
      } else {
        this.FlipTipsPage();
      }
      this.slideUpGestureComponent();
    }
    .backgroundColor(this.mWindowData.pageBackgroundColor)
    .width('100%')
    .height('100%')
    .transition(TransitionEffect.OPACITY
      .animation({
        duration: FlashlightTipsConstants.QUIT_ANIMATION_DELAY,
        curve: Curve.Linear
      }))
    .visibility(this.mWindowData.isShowPage ? Visibility.Visible : Visibility.Hidden);
  }
}