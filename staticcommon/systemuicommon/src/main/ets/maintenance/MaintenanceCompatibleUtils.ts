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
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';
import { resourceManager } from '@kit.LocalizationKit';
import { BaseNotification } from '../model/BaseNotification';
import { NotificationBase } from '../model/NotificationBase';
import { LiveNotification } from '../live/model/LiveNotification';
import { MaintenanceUtils } from './MaintenanceUtils';
import { LiveViewData } from '../liveview/data/LiveViewData';
import { LiveCardOtherModel } from '../live/model/LiveCardOtherModel';
import { LiveExtensionType } from '../live/model/LiveCommonModel';

const log = LogHelper.getLogHelper(LogDomain.SYS_UI, 'MaintenanceCompatibleUtils');

export type CompatibleNotification = BaseNotification | NotificationBase;

export type CompatibleLiveView = BaseNotification | LiveNotification;

/**
 * 打点兼容工具类
 */
export class MaintenanceCompatibleUtils {
  /**
   * 判断是否实况通知
   * @param ntf
   * @returns
   */
  public static isLiveView(ntf: CompatibleNotification): ntf is CompatibleLiveView {
    if (ntf instanceof NotificationBase) {
      return ntf.isLiveView();
    }
    return ntf.isLiveType();
  }

  public static getSoundDescriptor(ntf: CompatibleNotification): resourceManager.RawFileDescriptor {
    return ntf instanceof BaseNotification ? ntf.soundDescriptor : ntf.customSound;
  }

  public static getEvent(ntf: CompatibleLiveView): number {
    let event: string | undefined = undefined;
    if (ntf instanceof LiveNotification) {
      event = ntf.card?.isOtherCard() ? ntf.card.event : undefined;
    } else {
      event = ntf.liveViewData?.event;
    }
    return MaintenanceUtils.getLiveEvent(event);
  }

  public static getLiveExtend(live: CompatibleNotification | LiveViewData): Record<string, string> | undefined {
    if (live instanceof BaseNotification || live instanceof LiveViewData) {
      return MaintenanceUtils.getLiveExtend(live);
    }

    if (live instanceof LiveNotification && live.card instanceof LiveCardOtherModel) {
      let result = {
        type: live.card.extensionType.toString(),
        digest: '',
      };

      if (live.card.extensionType === LiveExtensionType.NORMAL_TEXT ||
        live.card.extensionType === LiveExtensionType.CAPSULE_TEXT) {
        result.digest = live.card.extensionText || '';
      } else if (live.card.extensionType === LiveExtensionType.PICTURE ||
        live.card.extensionType === LiveExtensionType.ICON) {
        result.digest = live.card.extensionPicRes || 'pixelMap';
      }

      return result;
    }

    return undefined;
  }

  public static isPhoneCall(live: CompatibleNotification | LiveViewData): boolean {
    if (live instanceof BaseNotification || live instanceof LiveViewData) {
      return MaintenanceUtils.isPhoneCall(live);
    }
    if (live instanceof LiveNotification) {
      return live.isPhoneCall();
    }
    return false;
  }

  public static getPhoneButtonSize(ntf: CompatibleLiveView | LiveViewData): number {
    if (ntf instanceof LiveNotification) {
      return ntf.card?.isSystemCard() ? ntf.card.buttons?.length ?? 0 : 0;
    } else {
      return MaintenanceUtils.getPhoneButtonSize(ntf);
    }
  }
}