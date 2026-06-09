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
import { ResUtils } from '@ohos/windowscene';

/**
 * 状态栏资源样式
 *
 * @since 2022-10-26
 */
export class StatusBarStyle {
    /**
     * 状态栏顶部padding
     */
    public statusBarTopPadding: string = CommonUtils.splicePx(0);

    /**
     * 状态栏左侧padding
     */
    public statusBarLeftPadding: string = CommonUtils.splicePx(0);

    /**
     * 状态栏右侧padding
     */
    public statusBarRightPadding: string = CommonUtils.splicePx(0);

    /**
     * 状态栏顶层style
     *
     */
    initStatusBarStyle(): void {
        this.initPhoneStyle();
    }
    /**
     * Phone状态栏样式
     */
    private initPhoneStyle(): void {
        // 左右间距默认12，根据避孔、曲面调整
        let padding = CommonUtils.spliceVp(ResUtils.getNumber($r('app.float.status_bar_phone_left_padding')));
        this.statusBarTopPadding = CommonUtils.spliceVp(ResUtils.getNumber($r('app.float.status_bar_top_padding')));
        this.statusBarLeftPadding = padding;
        this.statusBarRightPadding = padding;
    }
}