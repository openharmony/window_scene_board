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

import { CommonUtils } from '@ohos/basicutils';
import { RTLUtil } from '@ohos/componenthelper';
import { ResUtils } from '@ohos/windowscene';
import { NotificationAnimationParas } from './NotificationAnimationParas';
import { NotificationType } from './NotificationType';
import { DropDownPanelManager } from '@ohos/systemuicommon/Index';
import { fontScaleManager,
    FontScaleState
} from '@ohos/systemuicommon';

/**
 * Utils for Notification
 *
 * @since 2022-12-21
 */
export class NotificationUtils {
    static getNtfItemTransX(ntfAniParameters: NotificationAnimationParas): number {
        if (CommonUtils.isInvalid(ntfAniParameters?.ntfItemTranslateX)) {
            return 0;
        }
        return ntfAniParameters.ntfItemTranslateX;
    }

    static getNtfItemTransY(ntfAniParameters: NotificationAnimationParas): number {
        if (CommonUtils.isInvalid(ntfAniParameters?.ntfItemTranslateY)) {
            return 0;
        }
        return ntfAniParameters.ntfItemTranslateY;
    }

    static getNtfItemOpacity(ntfAniParameters: NotificationAnimationParas): number {
        if (CommonUtils.isInvalid(ntfAniParameters?.clearAnimOpacity)) {
            return 1;
        }
        return ntfAniParameters.clearAnimOpacity;
    }

    static getNtfItemScale(ntfAniParameters: NotificationAnimationParas): number {
        if (CommonUtils.isInvalid(ntfAniParameters?.clearAnimScale)) {
            return 1;
        }
        return ntfAniParameters.clearAnimScale;
    }

    static getNtfItemRotateAngle(ntfAniParameters: NotificationAnimationParas) {
        if (CommonUtils.isInvalid(ntfAniParameters?.ntfItemRotateAngels)) {
            return 0;
        }
        return ntfAniParameters.ntfItemRotateAngels;
    }

    static getNtfItemRotateCenterY(ntfAniParameters: NotificationAnimationParas) {
        if (CommonUtils.isInvalid(ntfAniParameters?.ntfItemRotateCenterY)) {
            return '50%';
        }
        return ntfAniParameters.ntfItemRotateCenterY;
    }

    static getNtfTimeStampByBoard(isKeyGuard: boolean): string {
        return isKeyGuard ? '' : `${DropDownPanelManager.getLastDropdownTime()}`;
    }

    static getNtfTimeStampByType(ntfType: number): string {
        return NotificationUtils.getNtfTimeStampByBoard(NotificationType.isKeyguard(ntfType));
    }

    static getRTLValue(value: number): number {
      return RTLUtil.isRTL() ? -value : value;
    }

    static getActionBtnHeight(isShowDropBar: boolean): number {
        let fontScaleState = fontScaleManager.getSysFontScaleState();
        let result: number = ResUtils.getNumber($r('app.float.ntf_text_line_height')) * fontScaleState.getFontScale() +
            2 * ResUtils.getNumber($r('app.float.ntf_buttons_top_bottom_margin'));
        // 有下拉bar时，按钮高度增加bar的高度
        if (isShowDropBar) {
            result = result + ResUtils.getNumber($r('app.float.ntf_has_drop_bar_add_height'))
        }
        return result;
    }
}

export class ChildFunctionWrapper {
    public checkBool = (): boolean => {return false;}
}