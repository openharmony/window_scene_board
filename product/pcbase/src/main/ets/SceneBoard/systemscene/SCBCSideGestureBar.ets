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
import { WindowConstants } from '@ohos/commonconstants/src/main/ets/TsIndex';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { BaseViewController } from '@ohos/frameworkcommon';
import { viewMgrPolicy, ViewType } from '@ohos/frameworkwrapper';
import { SCBScreenProperty, SCBScreenSessionManager, sSCBOobeManager } from '@ohos/windowscene';
import { MultiInputViewModel } from '@ohos/multiinput';

const TAG = 'SCBCSideGestureBar';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);
const GUESTER_HOTAREA_DISTANCE = 42;
const MOUSE_HOTAREA_DISTANCE = 30;

@Component
export struct SCBCSideGestureBar {
  @Link screenProp: SCBScreenProperty;
  @State viewController: BaseViewController = new BaseViewController(ViewType.C_SIDE_GUSTURE_TOP_BAR);
  persistentId: number = 0;
  startX: number = 0;
  startY: number = 0;
  /**
   * 最小滑动距离
   */
  private touchSlop: number = 10;

  private onTouchEvent(event?: TouchEvent): void {
    if (!event) {
      log.showError('touchEvent is invalid');
      return;
    }
    // oobe intercept
    if (sSCBOobeManager.isEnable()) {
      return;
    }
    switch (event.type) {
      case TouchType.Down:
        this.startX = event.changedTouches[0].screenX;
        this.startY = event.changedTouches[0].screenY;
        log.showInfo(`onTouchEvent touchStart, startX: ${this.startX}, startY: ${this.startY}`);
        break;
      case TouchType.Move:
        this.touchMove(event);
        break;
      case TouchType.Up:
      case TouchType.Cancel:
        break;
    }
  }

  private touchMove(event: TouchEvent): void {
    let newY = event.changedTouches[0].screenY;
    let startY = this.startY;

    let moveY = newY - startY;
    log.showInfo(`onTouchEvent Move moveY: ${moveY}`);
    // 滑动距离过小
    if (moveY < this.touchSlop) {
      return;
    }
    log.showInfo(`screenProp.width is ${this.screenProp.width}, startX is ${this.startX}`);
    MultiInputViewModel.getInstance().updateCSideTitleFromGesture(true);
    setTimeout(() => {
      MultiInputViewModel.getInstance().updateCSideTitleFromGesture(false);
    }, 2500);
  }

  private screenPropertyCallback = (screenProperty: SCBScreenProperty) => {
    this.updateRect(screenProperty);
  }

  private updateRect(screenProperty: SCBScreenProperty) {
    this.viewController.updateRect({
      top: px2vp(screenProperty.height / 2),
      left: 0,
      width: px2vp(screenProperty.width),
      height: GUESTER_HOTAREA_DISTANCE
    })
  }

  aboutToAppear() {
    viewMgrPolicy.registerViewController(ViewType.C_SIDE_GUSTURE_TOP_BAR, this.viewController);
    this.viewController.updateId(this.persistentId);
    this.updateRect(this.screenProp);
    SCBScreenSessionManager.getInstance().registerScreenPropertyChangeCallbacks(this.screenPropertyCallback);
  }

  aboutToDisappear() {
    viewMgrPolicy.unregisterViewController(ViewType.C_SIDE_GUSTURE_TOP_BAR);
    SCBScreenSessionManager.getInstance().unRegisterScreenPropertyChangeCallbacks(this.screenPropertyCallback);
  }

  build() {
    Row() {
      Row()
        .width('100%')
        .height(MOUSE_HOTAREA_DISTANCE)
        .onHover((isHover) => {
          if (isHover) {
            MultiInputViewModel.getInstance().showCSideFloatingTitle();
          }
        })
    }
    .alignItems(VerticalAlign.Top)
    .width('100%')
    .height('100%')
    .onTouch((event?: TouchEvent) => this.onTouchEvent(event))
  }
}