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

export class Constants {
  public static readonly DIALOG_MAX_HEIGHT = 694;
  public static readonly SHADOW_RADIUS = 120;
  public static readonly SHADOW_OFFSET_X = 0;
  public static readonly SHADOW_OFFSET_Y = 20;
  public static readonly DIALOG_BOARDER_RADIUS = 16;
  public static readonly SESSION_COLOR_DARK = '#4D000000'; // 深色模式弹窗阴影颜色
  public static readonly SESSION_COLOR = '#33000000'; // 弹窗阴影颜色
  public static readonly DIALOG_WIDTH = 400;
  public static readonly QUARTER_OF_SCREEN = 4;
  public static readonly ONE_HALF_OF_SCREEN = 2;

  public static readonly REBOOT = 'reboot';
  public static readonly SHUTDOWN = 'shutdown';
  public static readonly LOGOUT = 'logout';

  public static readonly VIRTUAL_MACHINE_KEY = 'hwf.shutdown.allowed';
  public static readonly VIRTUAL_MACHINE_DIALOG_SHOW = 'hwf.terminate.flag';
  public static readonly LOGOUT_FROM_SCREEN_LOCK = 'logout_from_screen_lock';
}