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

import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import NotificationConstant from '../common/NotificationConstant';
import { NotificationGlassVm } from '../vm/NotificationGlassVm';
import { GlassNotificationGroupItem } from './GlassNotificationGroupItem';
import { GlassNotificationSingleItem } from './GlassNotificationSingleItem';

const TAG = 'GlassNotificationListItem';
const log = LogHelper.getLogHelper(LogDomain.VISION_GLASS, TAG);

@Component
export struct GlassNotificationListItem {
  @ObjectLink @Watch('onNotificationChange') notificationGlassVm: NotificationGlassVm;

  aboutToAppear(): void {
    log.showInfo(`aboutToAppear`);
  }

  aboutToDisappear(): void {
    log.showInfo(`aboutToDisappear`);
  }

  onNotificationChange(): void {
    log.showInfo(`onNotificationChange, isGroup ${this.notificationGlassVm.isGroup},child num is ${this.notificationGlassVm.getChildrenSize()}`);
  }

  build() {
    Column() {
      if (this.notificationGlassVm.isGroup) {
        GlassNotificationGroupItem({ notificationGlassVm: this.notificationGlassVm })
      } else {
        GlassNotificationSingleItem({
          notificationGlassVm: this.notificationGlassVm,
          glassBorderRadius: NotificationConstant.BORDERRADIUS_32
        })
      }
    }
  }
}