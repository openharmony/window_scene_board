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
import { NotificationEntry } from '@ohos/notificationcomponent/src/main/ets/model/NotificationEntry';
import GlassNtfConstant from '../common/GlassNtfConstant';
import { GlassBannerPanelManager } from '../manager/GlassBanerPanelManager';
import { GlassNtfHintItem } from './GlassNtfHintItem';
import { GlassNtfLiveItem } from './GlassNtfLiveItem';
import { GlassNtfNormalItem } from './GlassNtfNormalItem';

const log: LogHelper = LogHelper.getLogHelper(LogDomain.VISION_GLASS, 'GlassNtfSingleItem');

@Component
export struct GlassNtfSingleItem {
  @Consume ntf: NotificationEntry | null;
  @Consume @Watch('onNtfChange') ntfExpand: boolean;

  aboutToAppear(): void {
    log.showInfo(`aboutToAppear`);
  }

  aboutToDisappear() {
    log.showInfo(`aboutToDisAppear`);
  }

  private isNtfAsRequired(): boolean {
    log.showInfo(`isNtfAsRequired`);
    if (!this.ntf) {
      return false;
    }
    if (this.ntf.isLiveType() && this.ntf.creatorBundleName !== GlassNtfConstant.PHONE_BUNDLE_NAME) {
      return false;
    }
    if (!this.ntf.isLiveType()) {
      if (this.getNtfTitle() === '' || this.getNtfContent() === '' || !this.ntf.deliveryTime) {
        return false;
      }
    }
    if (this.ntf.actionButtons.length > 0 && !this.isNtfContact()) {
      return false;
    }
    log.showInfo(`isNtfAsRequired,true`);
    return true;
  }

  private isNtfContact(): boolean {
    log.showInfo(`isNtfContact`);
    if (this.ntf?.creatorBundleName === GlassNtfConstant.MESSAGE_BUNDLE_NAME) {
      log.showInfo(`isNtfContact,true`);
      return true;
    }
    return false;
  }

  private getNtfTitle(): string {
    let title = '';
    if (!this.ntf) {
      return title;
    }
    if (this.ntf.isExpandable) {
      title = this.ntf.notificationContent.expandedTitle;
    } else {
      title = this.ntf.notificationContent.contentTitle;
    }
    return title;
  }

  private getNtfContent(): string {
    let content = '';
    if (!this.ntf) {
      return content;
    }
    if (this.ntf.isExpandable) {
      content = this.ntf.notificationContent.expandedContentText;
    } else {
      content = this.ntf.notificationContent.contentText;
    }
    return content;
  }

  private onNtfChange(): void {
    if (!this.ntf) {
      log.showInfo(`onNtfChange,ntf is invalid`);
      return;
    }
    GlassBannerPanelManager.getInstance().updateWindowRectByNtfType(this.ntf, this.ntfExpand);
  }

  build() {
    if (this.ntf) {
      Column() {
        if (!this.isNtfAsRequired()) {
          GlassNtfHintItem();
        } else if (this.ntf.isLiveType()) {
          GlassNtfLiveItem();
        } else {
          GlassNtfNormalItem();
        }
      }
      .width('100%')
      .height('100%')
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Start)
    }
  }
}