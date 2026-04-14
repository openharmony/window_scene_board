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
const PC_DIALOG_WIDTH: Dimension = 400;
const PC_DIALOG_HEIGHT: Dimension = 378;
const PC_DIALOG_RADIUS: Dimension = 16;

export default class NtfConfigUtil {
  public static alignment: DialogAlignment = DialogAlignment.Bottom;
  public static showInSubWindow: boolean = false;
  public static customStyle: boolean = true;
  // customStyle为true时,不支持设置弹框宽高,宽高属性为PC设置
  public static dialogWidth: Dimension = '100%';
  public static dialogHeight: Dimension = '100%';
  public static cornerRadius: Dimension = 32;

  public static initPcConfig() {
    NtfConfigUtil.alignment = DialogAlignment.Center;
    NtfConfigUtil.showInSubWindow = true;
    NtfConfigUtil.customStyle = false;
    NtfConfigUtil.dialogWidth = PC_DIALOG_WIDTH;
    NtfConfigUtil.dialogHeight = PC_DIALOG_HEIGHT;
    NtfConfigUtil.cornerRadius = PC_DIALOG_RADIUS;
  }

  public static initTvConfig() {
    NtfConfigUtil.alignment = DialogAlignment.Center;
    NtfConfigUtil.showInSubWindow = true;
    NtfConfigUtil.dialogWidth = '100%';
  }
}