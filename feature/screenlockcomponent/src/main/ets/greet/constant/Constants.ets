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
import { curves } from '@kit.ArkUI';

export default class Constants {
  public static readonly GREET_FLAG: string = 'intelligent.scene.greet';
  public static readonly FLAG_0: string = '0';
  public static readonly FLAG_1: string = '1';
  public static readonly NUMBER_0: number = 0;
  public static readonly NUMBER_1: number = 1;
  public static readonly CLOCK_LISTENER: string = 'clock_listener';
  public static readonly ART_SIGN_LISTENER: string = 'art_sign_listener';
  public static readonly FORM_LISTENER: string = 'form_listener';
  public static readonly GREET_APPEAR_CURVE_40_60: ICurve = curves.cubicBezierCurve(0.4, 0.0, 0.4, 1.0);
  public static readonly GREET_APPEAR_CURVE_20_80: ICurve = curves.cubicBezierCurve(0.2, 0.0, 0.2, 1.0);
  public static readonly GREET_APPEAR_INTERPOLATE_CURVE_228_30: ICurve = curves.interpolatingSpring(0, 1, 228, 30);
  public static readonly GREET_BUNDLE_NAME: string = 'com.ohos.intelligentscene';
  public static readonly GREET_ABILITY_NAME: string = 'IntelligentSceneGreetUIExtAbility';
  public static readonly GREET_ABILITY_EXT_TYPE: Record<string, Object> | undefined = {
    'ability.want.params.uiExtensionType': 'sys/commonUI'
  };
}

export enum SlGreetModeReportScene {
  CLiCK_IMMERSIVE = 'CLiCK_IMMERSIVE',
  TO_EDIT = 'TO_EDIT',
  GREET_UI_RELEASE = 'GREET_UI_RELEASE',
  GREET_UI_ERROR = 'GREET_UI_ERROR',
  UNLOCK_COMMON = 'UNLOCK_COMMON',
  UNLOCK_FOR_CLOCK_ONE_SHOT = 'UNLOCK_FOR_CLOCK_ONE_SHOT',
  DESKTOP_TO_AOD_OR_SL = 'DESKTOP_TO_AOD_OR_SL',
  SCREEN_OFF = 'SCREEN_OFF',
  FAKE_AOD_STATE = 'FAKE_AOD_STATE',
  NORM_SHOW = 'NORM_SHOW',
  UNKNOWN = 'UNKNOWN',
}

export interface SlGreetStateListener {
  onGreetShow: (isAni?: boolean) => void;

  onGreetHide: (isAni?: boolean) => void;
}
