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

import { NotificationNormalVm } from '@ohos/notificationcomponent/newIndex';
import { IImmersiveNtfNormalVm } from '../../../common/interface/IImmersiveNtfNormalVm';
import { ImmNormalItemDoubleTapHandler } from '../gesture/ImmNormalItemDoubleTapHandler';

/**
 * 沉浸列表普通通知单条目业务管理
 */
@ObservedV2
export class ImmersiveNtfNormalVm extends NotificationNormalVm implements IImmersiveNtfNormalVm {
  // 单双击处理器
  private doubleTapHandler: ImmNormalItemDoubleTapHandler = new ImmNormalItemDoubleTapHandler(this);

  init(): void {
    super.init();
    this.doubleTapHandler.setClickCallback(() => {
      super.onClick();
    });
  }

  destroy(): void {
    super.destroy();
    this.doubleTapHandler.setClickCallback(undefined);
  }

  onClick(): void {
    this.doubleTapHandler.requestOnClick();
  }
}