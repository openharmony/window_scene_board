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

export default class Constants {
  // 自由多窗属性的取值
  public static readonly WINDOWS_PCMODE_SWITCH_STATUS_TRUE: string = 'true';
  public static readonly WINDOWS_PCMODE_SWITCH_STATUS_FALSE: string = 'false';

  // 防窥保护属性的取值
  public static readonly ANTI_PEEPING_OPEN: string = '0';
  public static readonly ANTI_PEEPING_ClOSE: string = '1';

  // 防窥ccm的key及其取值
  public static readonly CONST_PC_SERVICE_ANTI_PEEPING_KEY: string = 'const.pc_security.anti_peeping';
  public static readonly CONST_PC_SERVICE_ANTI_PEEPING_TRUE: string = 'true';
  public static readonly CONST_PC_SERVICE_ANTI_PEEPING_FALSE: string = 'false';

  /**
   * 防窥打点
   * SWITCH_WHERE	切换位置（0-控制中心，1-设置）
   * SWITCH_TYPE	切换方式（0-开启，1-关闭）
   * SWITCH_RESULT	切换结果（0-切换成功，1-切换失败）
   * */
  public static readonly SWITCH_WHERE_CONTROL_CENTER = '0';
  public static readonly SWITCH_TYPE_OPEN = '0';
  public static readonly SWITCH_TYPE_CLOSE = '1';
  public static readonly SWITCH_RESULT_SUCCESS = 0;
  public static readonly SWITCH_RESULT_FAILED = 1;
}

/**
 * NORMAL：按钮可用，其他：按钮不可用原因
 * */
export enum ButtonStatus {
  NORMAL = '',
  CAMERA_OCCUPIED = 'app.string.camera_occupied',
  FREE_WINDOW_CLOSED = 'app.string.free_window_closed',
}
