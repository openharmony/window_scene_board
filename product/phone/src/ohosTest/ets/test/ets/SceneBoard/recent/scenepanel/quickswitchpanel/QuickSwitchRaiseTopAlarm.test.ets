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

import {
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  it,
  describe,
  expect,
  TestType,
  Size,
  Level,
} from '@ohos/hypium';
import {
  SCBSceneContainerSession,
  SCBSceneContainerSessionArray,
  SCBSceneInfo,
  SCBScenePanelManager,
  SCBSceneSession,
  SCBScreenProperty
} from '@ohos/windowscene';
import sceneSessionManager from '@ohos.sceneSessionManager';
import {
  QuickSwitchRaiseTopAlarm
} from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/quickswitchpanel/QuickSwitchRaiseTopAlarm';
import screenSessionManager from '@ohos.screenSessionManager';

export default function QuickSwitchRaiseTopAlarmTest() {
  describe('QuickSwitchRaiseTopAlarmTest', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
    let screenProp: screenSessionManager.ScreenProperty = {
      rotation: 1,
      bounds: {
        left: 1,
        top: 1,
        width: 1,
        height: 1,
        radius: 1,
      },
      fakeBounds: {
        left: 0,
        top: 0,
        width: 0,
        height: 0,
        radius: 0
      },
      isFakeInUse: false,
      rsId: 0,
    };
    scbScreenProperty.update(screenProp);
    let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);

    let scbSceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName1', 'moduleName1', 'abilityName1');
    let primarySession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
    let scbSceneContainer: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, new SCBScreenProperty());
    let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
    totalContainerSessionList.add(scbSceneContainer);
    let secondScbSceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName2', 'moduleName2', 'abilityName2');
    let secondPrimarySession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(secondScbSceneInfo), secondScbSceneInfo);
    let secondScbSceneContainer2: SCBSceneContainerSession = new SCBSceneContainerSession(secondPrimarySession, new SCBScreenProperty());
    totalContainerSessionList.add(secondScbSceneContainer2);
    let screenProp1: screenSessionManager.ScreenProperty = {
      rotation: 1,
      bounds: {
        left: 1,
        top: 1,
        width: 1,
        height: 1,
        radius: 1,
      },
      fakeBounds: {
        left: 1,
        top: 1,
        width: 1,
        height: 1,
        radius: 1,
      },
      isFakeInUse: true,
      rsId: 0,
    };
    let scbScreenProperty1: SCBScreenProperty = new SCBScreenProperty();
    scbScreenProperty1.update(screenProp1);
    let quickSwitchRaiseTopAlarm: QuickSwitchRaiseTopAlarm = new QuickSwitchRaiseTopAlarm();

    it('QuickSwitchRaiseTopAlarm_start_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      quickSwitchRaiseTopAlarm.start(null);
      expect((quickSwitchRaiseTopAlarm as object)['containerSessionToTop']).assertEqual(null);
    })

    it('QuickSwitchRaiseTopAlarm_start_test_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      quickSwitchRaiseTopAlarm.start(scbSceneContainer);
      expect((quickSwitchRaiseTopAlarm as object)['containerSessionToTop']).assertEqual(scbSceneContainer);
    })

    it('QuickSwitchRaiseTopAlarm_onAlarm_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      quickSwitchRaiseTopAlarm.start(null);
      (quickSwitchRaiseTopAlarm as object)['onAlarm']();
      expect((quickSwitchRaiseTopAlarm as object)['containerSessionToTop']).assertEqual(null);
    })

    it('QuickSwitchRaiseTopAlarm_onAlarm_test_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      quickSwitchRaiseTopAlarm.start(scbSceneContainer);
      (quickSwitchRaiseTopAlarm as object)['onAlarm']();
      expect((quickSwitchRaiseTopAlarm as object)['containerSessionToTop']).assertNull();
    })

    it('QuickSwitchRaiseTopAlarm_cancel_test', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      quickSwitchRaiseTopAlarm.cancel('test');
      expect((quickSwitchRaiseTopAlarm as object)['containerSessionToTop']).assertEqual(null);
    })

    it('QuickSwitchRaiseTopAlarm_startImmediately_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      quickSwitchRaiseTopAlarm.startImmediately(null, 'test');
      expect((quickSwitchRaiseTopAlarm as object)['containerSessionToTop']).assertEqual(null);
    })

    it('QuickSwitchRaiseTopAlarm_startImmediately_test_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      quickSwitchRaiseTopAlarm.startImmediately(scbSceneContainer, 'test');
      expect((quickSwitchRaiseTopAlarm as object)['containerSessionToTop']).assertNull();
    })
  })
}