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

import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG = 'NotificationGestureModifier';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

interface ItemGestureCallback {
  handleDoubleTwiceClick: () => void;
  handleDoubleOnceClick: () => void;
  handleSingleClick: () => void;
}

/**
 * 单条通知动态绑定手势
 */
export class ItemGestureModifier implements GestureModifier {
  public isSupportDouble: boolean = true
  public callback?: ItemGestureCallback;
  private doubleGestureGroupHandler: GestureGroupHandler =
    new GestureGroupHandler({
      mode: GestureMode.Exclusive, gestures: [
        new TapGestureHandler({ count: 2 }).onAction(() => this.callback?.handleDoubleTwiceClick()),
        new TapGestureHandler({ count: 1 }).onAction(() => this.callback?.handleDoubleOnceClick())
      ]
    }
    );
  private singleGestureGroupHandler: GestureGroupHandler =
    new GestureGroupHandler({
      mode: GestureMode.Exclusive, gestures: [
        new TapGestureHandler({ count: 1 }).onAction(() => this.callback?.handleSingleClick())
      ]
    }
    );

  applyGesture(event: UIGestureEvent): void {
    log.showInfo('applyGesture for item: support double=' + this.isSupportDouble);
    event.clearGestures();
    if (this.isSupportDouble) {
      event.addGesture(this.doubleGestureGroupHandler);
      return;
    }
    event.addGesture(this.singleGestureGroupHandler);
  }
}
