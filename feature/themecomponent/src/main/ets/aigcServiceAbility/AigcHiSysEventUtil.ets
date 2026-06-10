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
import { hiSysEvent } from '@kit.PerformanceAnalysisKit';
import { ThemeImageActiveParam } from './AigcConstant';
import { Log } from './IdlService/Log';

const TAG: string = '[AigcService]AigcHiSysEventUtil';

export class ReportParams {
  public static PACKAGE_NAME: string = 'com.ohos.sceneboard';
  public static PROCESS_NAME: string = 'sceneBoard';
}

export class AigcHiSysEventUtil {

  private static SCENE_BOARD_UE_DOMAIN: string = 'THEMEEDITOR_UE';
  // X宇宙打点
  public static THEME_IMAGE_ACTIVE: string = 'THEME_IMAGE_ACTIVE';
  /**
   * 上报X宇宙使能是否成功以及耗时
   *
   * @param costTime 时间
   * @param status 0：使能成功 1：使能失败
   */
  public static reportPandoraImageActive(costTime: number, status: boolean): void {
    Log.info(TAG, `reportPandoraImageActive THEME_IMAGE_ACTIVE cost time: ${costTime}, status: ${status}`);
    let params : ThemeImageActiveParam = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      COSTTIME: costTime,
      STATUS: !status,
    };
    // HiSysEventUtil.report(AigcHiSysEventUtil.SCENE_BOARD_UE_DOMAIN, AigcHiSysEventUtil.THEME_IMAGE_ACTIVE,
    //   hiSysEvent.EventType.BEHAVIOR, params);
  }
}
