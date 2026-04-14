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

/**
 * 包名，应用版本
 */
class ReportParams {
  public static PACKAGE_NAME: string = 'com.ohos.sceneboard';
  public static PROCESS_NAME: string = 'sceneBoard';
}

/**
 * 基础参数
 */
export class BaseParams {
  public PNAMEID: string = ReportParams.PACKAGE_NAME;
  public PVERSIONID: string = ReportParams.PROCESS_NAME;
}

/**
 * 设置开关参数
 */
export class SettingSwitchParams extends BaseParams {
  /**
   * 1:开 0:关 switch
   */
  public IS_ON: number = 0;
}