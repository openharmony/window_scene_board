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

import { LiveExtendType, OtherFormExtendShowType, SysTypeCode } from '../liveview/common/LiveConstants';
import { LiveButtonArray } from '../liveview/data/extend/LiveButtonData';
import { LiveOtherExtendData } from '../liveview/data/extend/LiveOtherExtendData';
import { LiveViewData } from '../liveview/data/LiveViewData';
import { LiveBaseTemplate } from '../liveview/data/template/LiveBaseTemplate';
import { LiveSystemTemplate } from '../liveview/data/template/LiveSystemTemplate';
import { BaseNotification } from '../model/BaseNotification';

enum LiveEventMap {
  UNKNOWN = -1,
  TAXI = 0,
  DELIVERY = 1,
  FLIGHT = 2,
  TRAIN = 3,
  QUEUE = 4,
  PICK_UP = 5,
  SCORE = 6,
  RENT = 7,
  TIMER = 8,
  WORKOUT = 9,
  NAVIGATION = 10,
};

/**
 * 打点工具类
 */
export class MaintenanceUtils {
  /**
   * 获取实况场景
   * @param ntf
   * @returns
   */
  public static getLiveEvent(event: string): number {
    return LiveEventMap[event] ?? LiveEventMap.UNKNOWN;
  }

  public static getLiveExtend(live: BaseNotification | LiveViewData): Record<string, string> | undefined {
    let extendData: LiveOtherExtendData;
    
    if (live instanceof BaseNotification) {
      extendData = (live.liveViewData.template as LiveBaseTemplate).getExtendData(
        LiveExtendType.TYPE_OTHER_EXTEND) as LiveOtherExtendData;
    } else if (live instanceof LiveViewData) {
      extendData = (live.template as LiveBaseTemplate).getExtendData(
        LiveExtendType.TYPE_OTHER_EXTEND) as LiveOtherExtendData;
    }

    if (extendData) {
      let result = {
        type: extendData.type.toString(),
        digest: '',
      };

      if (extendData.type === OtherFormExtendShowType.NORMAL_TEXT ||
        extendData.type === OtherFormExtendShowType.CAPSULE_TEXT) {
        result.digest = extendData.text || '';
      } else if (extendData.type === OtherFormExtendShowType.PICTURE ||
        extendData.type === OtherFormExtendShowType.ICON) {
        result.digest = extendData.picRes || 'pixelMap';
      }
      return result;
    }

    return undefined;
  }

  public static isPhoneCall(live: BaseNotification | LiveViewData): boolean {
    let isPhoneCall: boolean = false;

    if (live instanceof BaseNotification) {
      isPhoneCall = live.liveViewData?.isSysTypeCode(SysTypeCode.PHONE);
    } else if (live instanceof LiveViewData) {
      isPhoneCall = live?.isSysTypeCode(SysTypeCode.PHONE);
    }
    return isPhoneCall;
  }

  public static getPhoneButtonSize(live: BaseNotification | LiveViewData): number {
    let buttonData: LiveButtonArray = new LiveButtonArray();

    if (live instanceof BaseNotification) {
      buttonData = (live.liveViewData.template as LiveSystemTemplate).getExtendData(
        LiveExtendType.TYPE_COMMON_BUTTON) as LiveButtonArray;
    } else if (live instanceof LiveViewData) {
      buttonData = (live.template as LiveBaseTemplate).getExtendData(
        LiveExtendType.TYPE_OTHER_EXTEND) as LiveButtonArray;
    }
    return buttonData.length;
  }
}