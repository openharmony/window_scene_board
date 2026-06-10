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

import { ArrayUtils, LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { NotificationGlassVm, NotificationUtil } from '../vm/NotificationGlassVm';
import GlassNotificationActionButtonCard from './GlassNotificationActionButtonCard';
import GlassNotificationCard from './GlassNotificationCard';
import GlassNotificationLiveItem from './GlassNotificationLiveItem';
import GlassNotificationWrongCard from './GlassNotificationWrongCard';

const TAG = 'GlassNotificationSingleItem';
const log = LogHelper.getLogHelper(LogDomain.VISION_GLASS, TAG);

@Component
export struct GlassNotificationSingleItem {
  @ObjectLink @Watch('onNtfChange') notificationGlassVm: NotificationGlassVm;
  @Prop glassBorderRadius: string;
  private isInGroup: boolean = false;

  aboutToAppear(): void {
    log.showInfo(`aboutToAppear`);
  }

  aboutToDisappear(): void {
    log.showInfo(`aboutToDisappear`);
  }

  onNtfChange(): void {
    log.showInfo(`onNtfChange,hashcode is ${this.notificationGlassVm.hashCode},deliveryTime is ${this.notificationGlassVm.deliveryTime}`);
  }

  build() {
    if (!NotificationUtil.isNtfAsRequired(this.notificationGlassVm)) {
      GlassNotificationWrongCard({
        notificationGlassVm: this.notificationGlassVm,
        glassBorderRadius: this.glassBorderRadius
      })
    } else if (this.notificationGlassVm.isLiveType()) {
      GlassNotificationLiveItem({
        notificationGlassVm: this.notificationGlassVm,
        glassBorderRadius: this.glassBorderRadius
      });
    } else {
      if (ArrayUtils.isEmpty(this.notificationGlassVm.actionButtons)) {
        GlassNotificationCard({
          notificationGlassVm: this.notificationGlassVm,
          glassBorderRadius: this.glassBorderRadius
        })
      } else {
        GlassNotificationActionButtonCard({
          notificationGlassVm: this.notificationGlassVm,
          glassBorderRadius: this.glassBorderRadius,
          isInGroup: this.isInGroup
        })
      }
    }
  }
}
