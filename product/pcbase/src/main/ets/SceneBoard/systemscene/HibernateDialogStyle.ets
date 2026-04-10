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
interface HibernateDialogStyleProps {
  confirmBorderRadius: number;
  confirmDialogWidth: number;
  confirmDialogHeight: number;
  iconWidth: number;
  iconHeight: number;
  iconMarginLeft: number;
  iconMarginRight: number;
  iconMarginTop: number;
  iconMarginBottom: number;
  titleLineHeight: number;
  titleMarginLeft: number;
  titleMarginRight: number;
  titleMarginTop: number;
  titleMarginBottom: number;
  tipLineHeight: number;
  tipMarginLeft: number;
  tipMarginRight: number;
  tipMarginTop: number;
  tipMarginBottom: number;
  cancelButtonId: string;
  confirmButtonWidth: number;
  buttonHeight: number;
  confirmButtonSpacingSize: number;
  buttonMarginBottom: number;
  countDownNumber: number;
  confirmButtonBorderRadius: number;
  bigFontSize: number;
  minFontSize: number;
  confirmTitleMaxLines: number;
  shutdownTimerConstant: number;
}

export const hibernateDialogStyle: HibernateDialogStyleProps = {
  confirmBorderRadius: 16,
  confirmDialogWidth: 400,
  confirmDialogHeight: 226,
  iconWidth: 32,
  iconHeight: 32,
  iconMarginLeft: 184,
  iconMarginRight: 184,
  iconMarginTop: 24,
  iconMarginBottom: 15,
  titleLineHeight: 27,
  titleMarginLeft: 24,
  titleMarginRight: 24,
  titleMarginTop: 15,
  titleMarginBottom: 15,
  tipLineHeight: 21,
  tipMarginLeft: 24,
  tipMarginRight: 24,
  tipMarginTop: 15,
  tipMarginBottom: 16,
  cancelButtonId: 'ShutDownDialogCancelButton', // '取消'按钮的id，用于获焦
  confirmButtonWidth: 176,
  buttonHeight: 40,
  confirmButtonSpacingSize: 16,
  buttonMarginBottom: 16,
  countDownNumber: 30, // 关机倒计时从30s开始
  confirmButtonBorderRadius: 8,
  bigFontSize: 16,
  minFontSize: 8,
  confirmTitleMaxLines: 2,
  shutdownTimerConstant: 1000 //定时器
}