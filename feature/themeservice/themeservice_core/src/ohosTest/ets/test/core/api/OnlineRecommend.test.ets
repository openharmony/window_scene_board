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
import { describe, expect, it, Level, TestType } from '@ohos/hypium';
import { Constants, ThemeCode, ThemePackInfo, ThemeRecommendInfo } from '@ohos/themeservice_inner_api/Index';
import { FileUtil, NullableType, TsLog } from '@ohos/themeservicebase/Index';
import { RemoteCode } from '@ohos/themeservicebase/src/main/ets/remote/RemoteCode';
import { getThemePackParser } from '../../../../../main/ets/preset/ThemePackParser';
import { TSPathUtils } from '../../../../../main/ets/util/TSPathUtils';
import { TSOhosTestManger } from '../../../core/TSOhosTestManger';
import { AssertUtils } from '../../../core/util/AssertUtils';

const TAG: string = 'OnlineRecommend.test';

export default function OnlineRecommendTest() {
  describe('OnlineRecommendTest_Illegal_caller', () => {
    it('notifyOnlineRecommendationUpdate', Level.LEVEL0, async () => {
      await AssertUtils.expectErrorCode(() => TSOhosTestManger.getTsCoreRemoteApi()
        .notifyOnlineRecommendationUpdate([]), RemoteCode.ERR_ILLEGAL_CALLER);
    })
  })
  describe('OnlineRecommendTest', () => {
    it('test001_param_null', TestType.FUNCTION, async () => {
      let code: number = await TSOhosTestManger.hwAppCallApi(api => api.notifyOnlineRecommendationUpdate([]));
      expect(code).assertEqual(ThemeCode.ERROR_PARAMS);
      TsLog.debug(TAG, `notifyOnlineRecommendationUpdate_null code: ${code}`);
    });

    it('test002_param_empty', TestType.FUNCTION, async () => {
      let code: number = await TSOhosTestManger.hwAppCallApi(api => api.notifyOnlineRecommendationUpdate([]));
      TsLog.debug(TAG, `notifyOnlineRecommendationUpdate_empty code: ${code}`);
      expect(code).assertEqual(ThemeCode.ERROR_PARAMS);
    });

    it('test003_param_errorFilePath', TestType.FUNCTION, async () => {
      await testErrorFilePath();
    });

    it('test004_param_success', TestType.FUNCTION, async () => {
      await testParamSuccess();
    });
  })
}

async function testErrorFilePath() {
  let recommendInfoList: ThemeRecommendInfo[] = [];
  {
    let recommend: ThemeRecommendInfo = new ThemeRecommendInfo();
    recommend.contentId = 'contentId1';
    recommend.filePath = 'error/file';
    recommend.zhName = '推荐1';
    recommend.enName = 'recommend1';
    recommendInfoList.push(recommend);
  }
  let code: number =
    await TSOhosTestManger.hwAppCallApi(api => api.notifyOnlineRecommendationUpdate(recommendInfoList));
  TsLog.debug(TAG, `notifyOnlineRecommendationUpdate_param_errorFilePath code: ${code}`);
  expect(code).assertEqual(ThemeCode.ERROR_COPY_FILE);
}

async function testParamSuccess() {
  let recommendInfoList: ThemeRecommendInfo[] = [];
  let recommend: ThemeRecommendInfo = new ThemeRecommendInfo();
  recommend.contentId = 'contentId1';
  let themePackInfo: ThemePackInfo = await getThemePackParser().parseDefault();
  recommend.filePath = `${themePackInfo.srcPath}/description.json`;
  recommend.zhName = '推荐1';
  recommend.enName = 'recommend1';
  recommendInfoList.push(recommend);

  let code: number = await TSOhosTestManger.hwAppCallApi(api => api
    .notifyOnlineRecommendationUpdate(recommendInfoList));
  TsLog.debug(TAG, `notifyOnlineRecommendationUpdate_param_success code: ${code}`);
  expect(code).assertEqual(ThemeCode.SUCCESS);

  let result: NullableType<ThemeRecommendInfo[]> = await TSOhosTestManger.getTsCoreRemoteApi()
    .getOnlineRecommendation();
  expect(result).not().assertUndefined();
  expect(result![0].contentId).assertEqual(recommend.contentId);
  expect(result![0].zhName).assertEqual(recommend.zhName);
  expect(result![0].enName).assertEqual(recommend.enName);
  let fileName: string = `${recommend.contentId}${Constants.FILE_SUFFIX}${FileUtil.getFileSuffix(recommend.filePath)}`;
  expect(result![0].filePath).assertEqual(`${TSPathUtils.getTsOnlineRecommendPath()}/${fileName}`);
}
