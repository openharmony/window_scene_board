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
import { describe, expect, it } from '@ohos/hypium';
import {
  TARGET_LOCK,
  TConfigArg,
  ThemeInfo
} from '@ohos/themeservice_inner_api';
import { TsLog } from '@ohos/themeservicebase/Index';
import { ApplyConfigExecutor } from '../../../../../main/ets/service/impl/activate/ApplyConfigExecutor';
import { themeInfoService } from '../../../../../main/ets/service/impl/ThemeInfoServiceImpl';

const TAG: string = 'ApplyConfig.test';

export default function ApplyConfigTest() {
  describe('ApplyConfigTest', () => {
    it('test001_applyConfig_no_activated', 0, async () => {
      let tConfigArgs: TConfigArg[] = [];
      let themeInfo: ThemeInfo = await themeInfoService.get().getCurrentTheme();
      let ret: boolean = await new ApplyConfigExecutor(themeInfo).setCurrentThemeCfg(tConfigArgs);
      TsLog.debug(TAG, `test001_applyConfig_no_activated ret: ${ret} `);
      expect(ret).assertFalse();
    })

    it('test002_apply_activated_true', 0, async () => {
      let tConfigArgs: TConfigArg[] = [];
      let themeInfo: ThemeInfo = await themeInfoService.get().getCurrentTheme();
      let ret: boolean = await new ApplyConfigExecutor(themeInfo).setCurrentThemeCfg(tConfigArgs, true);
      TsLog.debug(TAG, `test002_apply_activated_true ret: ${ret} `);
      expect(ret).assertFalse();
    })

    it('test003_apply_activated_false', 0, async () => {
      let tConfigArgs: TConfigArg[] = [];
      let themeInfo: ThemeInfo = await themeInfoService.get().getCurrentTheme();
      let ret: boolean = await new ApplyConfigExecutor(themeInfo).setCurrentThemeCfg(tConfigArgs, false);
      TsLog.debug(TAG, `test003_apply_activated_false ret: ${ret} `);
      expect(ret).assertTrue();
    })

    it('test004_apply_activated_false', 0, async () => {
      let tConfigArgs: TConfigArg[] = [{
        target: TARGET_LOCK,
        qualifier: 'base',
        fileName: 'config.json',
        value: 'Config:{postion:2}'
      }];
      let themeInfo: ThemeInfo = await themeInfoService.get().getCurrentTheme();
      let ret: boolean = await new ApplyConfigExecutor(themeInfo).setCurrentThemeCfg(tConfigArgs, false);
      TsLog.debug(TAG, `test004_apply_activated_false ret: ${ret} `);
      expect(ret).assertTrue();
    })

    it('test005_apply_activated_true', 0, async () => {
      let tConfigArgs: TConfigArg[] = [{
        target: TARGET_LOCK,
        qualifier: 'base',
        fileName: 'config.json',
        value: 'Config:{postion:2}'
      }];
      let themeInfo: ThemeInfo = await themeInfoService.get().getCurrentTheme();
      let ret: boolean = await new ApplyConfigExecutor(themeInfo).setCurrentThemeCfg(tConfigArgs, true);
      TsLog.debug(TAG, `test005_apply_activated_true ret: ${ret} `);
      expect(ret).assertTrue();
    })
  })
}