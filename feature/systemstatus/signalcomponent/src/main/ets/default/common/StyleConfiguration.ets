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

import { CommonStyleManager } from '@ohos/systemuicommon';

const TAG = 'signal-StyleConfiguration';

export class SignalComponentStyle {
    public onlySignalImageWidth: Length = $r('app.float.only_signal_strength_width');
    public cellularImageWidth: Length = $r('app.float.signal_component_icon_width');
    public cellularImageWidthLong: Length = $r('app.float.signal_component_icon_long_width');
    public cellularImageAirWidth: Length = $r('app.float.signal_component_airplane_width');
    public cellularImageNoSimWidth: Length = $r('app.float.signal_component_nosim_width');
    public cellularImageHeight: Length = $r('app.float.signal_component_icon_height');
    public statusBarSignalTypeFontSize: Length = $r('app.float.status_bar_signal_type_font_size');
    public distributedImageWidth: Length = $r('app.float.distributed_modem_icon_width');
    public statusBarSignalUnknownFontSize: Length = $r('app.float.status_bar_signal_unknown_font_size');
    public signalTextMaxWeight: Length = $r('app.float.signal_text_max_width');
    public netSignalTextMaxWidth: Length = $r('app.float.status_bar_signal_net_signal_text_max_width');
    public stackSignalImageWidth: Length = $r('app.float.stack_signal_component_icon_width');
    public stack2gSignalTypeImageWidth: Length = $r('app.float.stack_signal_type_2g_icon_width');
    public stack3gSignalTypeImageWidth: Length = $r('app.float.stack_signal_type_3g_icon_width');
    public stack4gSignalTypeImageWidth: Length = $r('app.float.stack_signal_type_4g_icon_width');
    public stack4gPlusSignalTypeImageWidth: Length = $r('app.float.stack_signal_type_4gplus_icon_width');
    public stack5gSignalTypeImageWidth: Length = $r('app.float.stack_signal_type_5g_icon_width');
    public stackHSignalTypeImageWidth: Length = $r('app.float.stack_signal_type_h_icon_width');
    public stackHPlusSignalTypeImageWidth: Length = $r('app.float.stack_signal_type_hplus_icon_width');
    public stackXSignalTypeImageWidth: Length = $r('app.float.stack_signal_type_x_icon_width');
}

export default class StyleConfiguration {
    public static getSignalComponentStyle(): SignalComponentStyle {
        const key: string = TAG + '-SignalComponent';
        return CommonStyleManager.getStyle(key, SignalComponentStyle);
    }
}