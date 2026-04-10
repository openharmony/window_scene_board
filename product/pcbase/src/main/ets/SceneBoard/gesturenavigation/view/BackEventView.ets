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
import {
  DomainName,
  LogDomain,
  LogHelper,
  TraceUtil
} from '@ohos/basicutils';
import { SCBScreenProperty } from '@ohos/windowscene';
import { StyleConstants } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { ActionType, BackEventViewModel } from '@ohos/gestureback/src/main/ets/backevent/viewmodel/BackEventViewModel';

const TAG = 'BackEventView';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.GESTURE, TAG);

@Component
export struct BackEventView {
  private isLeftGesture: boolean = false;
  private responseViewModel: BackEventViewModel | null = null;
  @Link screenProperty: SCBScreenProperty;

  build() {
    Column() {

    }
    .id(this.isLeftGesture ? 'SCBGestureBackLeft' : 'SCBGestureBackRight')
    .focusable(false)
    .position({ x: this.isLeftGesture ? 0 : px2vp(this.screenProperty.width) })
    .markAnchor({ x: this.isLeftGesture ? 0 : StyleConstants.GESTURE_NAVIGATION_SIDE_WINDOW_WIDTH })
    .width(StyleConstants.GESTURE_NAVIGATION_SIDE_WINDOW_WIDTH)
    .height('100%')
    .onTouch((event?: TouchEvent) => {
      this.responseViewModel?.onTouchEvent(this.screenProperty.height, event);
    })
    .onClick(() => {
      this.responseViewModel?.onClickEvent();
    })
    .gesture(GestureGroup(GestureMode.Exclusive,
      LongPressGesture({ repeat: false })
        .onAction(() => {
          this.responseViewModel?.onLongPressGestureAction(ActionType.START);
        })
        .onActionEnd(() => {
          this.responseViewModel?.onLongPressGestureAction(ActionType.END);
        })
        .onActionCancel(() => {
          this.responseViewModel?.onLongPressGestureAction(ActionType.CANCEL);
        }),
      PanGesture({
        fingers: 1, direction: (this.isLeftGesture ? PanDirection.Right : PanDirection.Left) |
        PanDirection.Vertical, distance: 1
      })
        .onActionStart((event?: GestureEvent) => {
          log.showInfo(`onActionStart. isLeftArea=${this.isLeftGesture}`);
          TraceUtil.startTrace(DomainName.GESTURE, 'backGesture');
          this.responseViewModel?.onPanGestureActionStart(event);
        })
        .onActionUpdate((event?: GestureEvent) => {
          log.showDebug(`onActionUpdate. offsetX=${event?.offsetX}, offsetY=${event?.offsetY}`);
          this.responseViewModel?.onPanGestureActionUpdate(event);
        })
        .onActionEnd((event?: GestureEvent) => {
          log.showInfo('onActionEnd.');
          this.responseViewModel?.onPanGestureActionEnd(event);
          TraceUtil.endTrace(DomainName.GESTURE, 'backGesture');
        })
        .onActionCancel((event?: GestureEvent) => {
          this.responseViewModel?.onPanGestureActionCancel();
        })))
  }
}