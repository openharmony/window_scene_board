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
import { ResUtils } from '@ohos/windowscene';
import { FingerprintConstants, ScreenOnOffService, VerifyDataManager } from '@ohos/screenlockcommon';
import { AuthType } from '@ohos/screenlockcommon/src/main/ets/utils/AccountHelper';
import { AccessibilityUtil } from '@ohos/screenlockcommon/src/main/ets/utils/AccessibilityUtil';

const TAG = 'TemporaryPromptViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

export enum HidePromptCode {
    FINGERPRINT_ANTI_TOUCH_CAMERA = 1,
}

// prompt duration time(ms)
const DURATION_TIME: number = 2500;
const INTERVAL: number = 1000;
export default class TemporaryPromptViewModel {
    public isShowTemporaryPrompt: boolean = false;
    public temporaryPrompt: string | undefined = undefined;
    public mIsNeedShowFingerprintPrompt: boolean = true;
    private timerId: number = -1;
    private countDownTimerId: number = -1;
    private counter = 0;
    private refreshUnlockTipResult: Resource = this.refreshUnlockTip();
    private hidePromptCode: HidePromptCode | undefined;

    constructor(mIsNeedShowFingerprintPrompt: boolean) {
        this.mIsNeedShowFingerprintPrompt = mIsNeedShowFingerprintPrompt;
    }

    private refreshUnlockTip(): Resource {
        return this.mIsNeedShowFingerprintPrompt &&
            !VerifyDataManager.getInstance().getVerifyInfo(AuthType.FINGERPRINT).isStateLocked ?
        $r('app.string.lock_icon_tip_with_fingerprint') : $r('app.string.lock_icon_tip');
    }

    public showTemporaryPrompt(temporaryPrompt: string, delay?: number, isRefreshPrompt: boolean = true,
        hidePromptCode: number | undefined = undefined) {
        VerifyDataManager.getInstance().updateVerifyData();
        this.isShowTemporaryPrompt = true;
        this.hidePromptCode = hidePromptCode;
        if (this.timerId !== -1) {
            log.showInfo(`timer id is ${this.timerId}, need to clear timeout.`);
            clearTimeout(this.timerId);
            this.timerId = -1;
            this.temporaryPrompt = undefined;
            this.isShowTemporaryPrompt = false;
        }
        this.temporaryPrompt = temporaryPrompt;
        this.isShowTemporaryPrompt = true;
        let timerDelay: number = (delay === undefined || delay >= DURATION_TIME || delay <= 0) ? DURATION_TIME : delay;
        if (delay === 3000) {
            timerDelay = delay;
        }
        this.timerId = setTimeout(() => {
            log.showInfo(`duration time(${timerDelay}) temporary prompt`);
            this.temporaryPrompt = undefined;
            this.isShowTemporaryPrompt = false;
            if (isRefreshPrompt && AccessibilityUtil.isAccessibilityMode() &&
              ScreenOnOffService.getInstance().isScreenOn) {
                AccessibilityUtil.sendAccessibility(ResUtils.getInnerString(this.refreshUnlockTipResult));
            }
        }, timerDelay);

        if (AccessibilityUtil.isAccessibilityMode()) {
            AccessibilityUtil.sendAccessibility(this.temporaryPrompt);
        }
    }

    public hideTemporaryPrompt(hidePromptCode: number): void {
        if (hidePromptCode === this.hidePromptCode) {
            this.isShowTemporaryPrompt = false;
            this.hidePromptCode = undefined;
        }
    }

    /**
     * countdown
     */
    async countdown(remainTimes: number, freezingTime: number, isPsdFreezing: boolean, isFirst: boolean, callback: (remainTimes: number, freezingTime: number, isPsdFreezing: boolean) => Promise<string> ) : Promise<void> {
        log.showInfo(`countdown remainTimes:${remainTimes}, freezingTime:${freezingTime}, isPsdFreezing:${isPsdFreezing}.`);

        if (isFirst) {
            log.showInfo('first need to clean.');
            this.clearCountDownTimer();
            this.counter = 0;
        }


        if (remainTimes !== 0 || freezingTime <= 0 || freezingTime === FingerprintConstants.INVALID_DURATION) {
            log.showInfo(`remainTimes:${remainTimes}, freezingTime:${freezingTime}, so no need to count down.`);
            this.clearCountDownTimer();
            this.counter = 0;
            return;
        }

        if (!this.isShowTemporaryPrompt) {
            log.showInfo('no need to show temporary prompt, so no need to count down.');
            this.clearCountDownTimer();
            this.counter = 0;
            return;
        }

        if (this.counter * INTERVAL > DURATION_TIME) {
            log.showInfo(`counter is ${this.counter}, so no need to count down.`);
            this.clearCountDownTimer();
            this.counter = 0;
            return;
        }

        this.temporaryPrompt = await callback(remainTimes, freezingTime, isPsdFreezing);
        this.counter++;
        this.countDownTimerId = setTimeout(() => {
            this.countdown(remainTimes, freezingTime - INTERVAL, isPsdFreezing, false, callback)
        }, INTERVAL);
    }

    private clearCountDownTimer() {
        if (this.countDownTimerId !== -1) {
            log.showInfo(`timer id is ${this.countDownTimerId}, need to clear timeout.`);
            clearTimeout(this.countDownTimerId);
            this.countDownTimerId = -1;
        }
    }

}