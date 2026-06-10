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
  SCBSceneContainerSession,
  SCBSceneContainerSessionArray,
  SCBSceneInfo,
  SCBScenePanelManager,
  SCBSceneSession,
  SCBScreenProperty
} from '@ohos/windowscene/src/main/ets/TsIndex';
import {
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  it,
  describe,
  expect,
  Level,
} from '@ohos/hypium';
import screenSessionManager from '@ohos.screenSessionManager';
import {
  ZoomFollowingAnimations
} from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/apppanel/ZoomFollowingAnimations';
import sceneSessionManager from '@ohos.sceneSessionManager';

export default function ZoomFollowingAnimationsTest() {
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
  let scbSceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
  let primarySession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
  let zoomFollowingAnimations: ZoomFollowingAnimations = new ZoomFollowingAnimations(scenePanelManager);
  let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
  let eventArea: Area = {
    width: 0,
    height: 0,
    position: {
      x: 0, y: 0
    },
    globalPosition: {
      x: 0, y: 0
    }
  };
  let eventTarget: EventTarget = {
    area: eventArea
  };
  let event: GestureEvent = {
    target: eventTarget,
    timestamp: 0,
    source: 0,
    pressure: 0,
    tiltX: 0,
    tiltY: 0,
    sourceTool: 0,
    repeat: false,
    fingerList: [],
    offsetX: 0,
    offsetY: 0,
    angle: 0,
    speed: 0,
    scale: 0,
    pinchCenterX: 0,
    pinchCenterY: 0,
    velocityX: 0,
    velocityY: 0,
    velocity: 0
  };

  describe('ZoomFollowingAnimationsTest', () => {
    beforeAll(() => {})
    beforeEach(() => {})
    afterEach(() => {})
    afterAll(() => {})
    
    it('ZoomFollowingAnimations_updateAppZoomView_01', Level.LEVEL0, (): void => {
      (scenePanelManager as object)['containerSessionList'] = totalContainerSessionList;
      zoomFollowingAnimations.updateAppZoomView(event);
      expect(zoomFollowingAnimations).not().assertNull();
    })

    it('ZoomFollowingAnimations_updateAppZoomView_02', Level.LEVEL0, (): void => {
      (scenePanelManager as object)['containerSessionList'] = totalContainerSessionList;
      let scbSceneContainer: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, scbScreenProperty);
      (scbSceneContainer as object)['_isActive'] = false;
      totalContainerSessionList.add(scbSceneContainer);
      zoomFollowingAnimations.updateAppZoomView(event);
      expect(zoomFollowingAnimations).not().assertNull();
    })
  })
}