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

import { NtfPinTopLimitDialogConfig } from './NtfPinTopLimitDialogConfig';

export class NtfPinTopLimitDialogConfigTv extends NtfPinTopLimitDialogConfig {
  constructor() {
    super();
    //置顶通知超过限制提示弹框相关参数
    this.ntfAppIconTopMargin = 0;
    this.dialogTextRightPadding = 22 * 4.0 / 3.0;
    this.dialogTextTopPadding = 24 * 4.0 / 3.0;
    this.dialogTextBottomPadding = 0;
    this.dialogGridcolPadding = 26 * 4.0 / 3.0;
    this.dialogGridrowMargin = 24 * 4.0 / 3.0;
    this.dialogTextVerticalPadding = 15 * 4.0 / 3.0;
    this.ntfMenuDialogRadio = 24 * 4.0 / 3.0;
    this.titleContentFontSize = 20 * 4.0 / 3.0;
    this.ntfPinTopGridCloXGutter = 16 * 4.0 / 3.0;
    this.buttonTopMargin = 0;
    this.buttonBottomMargin = 0;
    this.buttonRowOutMargin = 0;
    this.buttonRowInnerMargin = 12 * 4.0 / 3.0;
    this.buttonOutTopMargin = 24 * 4.0 / 3.0;
    this.buttonOutBottomRightLeftMargin = 24 * 4.0 / 3.0;
    this.actionButtonBkgColor = '#33F1F3F5';
    this.buttonInnerLineVisibility = Visibility.None;
    this.actionButtonType = ButtonType.Capsule;
    this.colCount = 4;
    this.actionButtonWidth = 174 * 4.0 / 3.0;
    this.buttonEnabled = undefined;
    this.buttonOpacity = 1;
    this.buttonUnableOpacity = 0.4;

    this.ntfSettingDialogItemHeight = 40 * 4.0 / 3.0;
    this.ntfSettingDialogTitleHeight = 56 * 4.0 / 3.0;
    this.ntfPinTopAppIconSize = 64 * 4.0 / 3.0;
    this.ntfPinTopAppIconMargin = 0;
    this.ntfPinTopAppIconRowMarginGap = 12 * 4.0 / 3.0;
    this.ntfPinTopAppNameLineHeight = 19 * 4.0 / 3.0;
    this.ntfPinTopAppLayoutMargin = 12 * 4.0 / 3.0;
    this.ntfMenuDialogTextPadding = 24 * 4.0 / 3.0;
    this.ntfPinTopPaddingLeftRight = 16 * 4.0 / 3.0;

    this.ntfPinTopAppIconConstraintSize = 64 * 4.0 / 3.0;
    this.ntfPinTopAppIconCheckboxOffsetStart = 18 * 4.0 / 3.0;
    this.ntfPinTopAppIconCheckboxOffsetTop = 50 * 4.0 / 3.0;
    this.ntfPinTopAppIconCheckboxWidth = 20 * 4.0 / 3.0;
    this.ntfPinTopAppIconCheckboxHeight = 20 * 4.0 / 3.0;

    this.ntfPinTopAppNameFontSize = 14 * 4.0 / 3.0;
    this.ntfPinTopAppNameMaxFontSize = 14 * 4.0 / 3.0;
    this.ntfPinTopAppNameMinFontSize = 10 * 4.0 / 3.0;
    this.ntfPinTopAppNameTopMargin = 4 * 4.0 / 3.0;
    this.ntfTitleContentTopMargin = 24 * 4.0 / 3.0;
    this.ntfDialogContentFontSize = 16 * 4.0 / 3.0;
    this.ntfDialogContentLineHeight = 21 * 4.0 / 3.0;
    this.ntfActionButtonFontSize = 18 * 4.0 / 3.0;
    this.ntfActionButtonFontColor = '#e6ffffff';

    this.ntfGridColumnsGap = 39 * 4.0 / 3.0;
    this.ntfGridRowsGap = 12 * 4.0 / 3.0;

    this.dialogMaskBgColor = '#cc000000';
    this.dialogBgColor = '#e62e3033';
    this.ntfTitleContentAlign = TextAlign.Start;
  }
}