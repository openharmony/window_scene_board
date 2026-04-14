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

import { NtfPinTopLimitDialogConfig } from './NtfPinTopLimitDialogConfig';

export class NtfPinTopLimitDialogConfigPc extends NtfPinTopLimitDialogConfig {
  constructor() {
    super();
    //置顶通知超过限制提示弹框相关参数
    this.ntfAppIconTopMargin = 0;
    this.dialogTextRightPadding = 22;
    this.dialogTextTopPadding = 16;
    this.dialogTextBottomPadding = 0;
    this.dialogGridcolPadding = 0;
    this.dialogGridrowMargin = 24;
    this.dialogTextVerticalPadding = 15;
    this.ntfMenuDialogRadio = 16;
    this.titleContentFontSize = 20;
    this.ntfPinTopGridCloXGutter = 16;
    this.buttonTopMargin = 0;
    this.buttonBottomMargin = 0;
    this.buttonRowOutMargin = 0;
    this.buttonRowInnerMargin = 0;
    this.buttonOutTopMargin = 16;
    this.buttonOutBottomRightLeftMargin = 16;
    this.actionButtonBkgColor = $r('sys.color.comp_background_tertiary');
    this.buttonInnerLineVisibility = Visibility.Hidden;
    this.actionButtonType = ButtonType.Normal;
    this.colCount = 4;
    this.actionButtonWidth = 176;
    this.buttonEnabled = undefined;
    this.buttonOpacity = 1;
  }
}