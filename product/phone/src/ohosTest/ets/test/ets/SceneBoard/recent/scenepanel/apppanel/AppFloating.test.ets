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
  MockKit,
  when
} from '@ohos/hypium';
import { AppFloating } from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/apppanel/AppFloating';
import {
  SCBSceneContainerSession,
  SCBSceneContainerSessionArray,
  SCBSceneInfo,
  SCBScenePanelManager,
  SCBSceneSession,
  SCBScreenProperty} from '@ohos/windowscene';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { DeviceHelper } from '@ohos/frameworkwrapper';

let scenePanelManager: SCBScenePanelManager = new SCBScenePanelManager();
let appFloating: AppFloating = new AppFloating(scenePanelManager);
let scbSceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
let scbSceneSession: SCBSceneSession =
  new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
let container: SCBSceneContainerSession = new SCBSceneContainerSession(scbSceneSession, new SCBScreenProperty());

export default function AppFloatingTest() {
  describe('AppFloatingTest', (): void => {
    it('floatingSceneToFullAnimation_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      container.floatingParam.minAnimationNum = 3;
      container.needRenderScale.setScaleX(1);
      container.needRenderScale.setScaleY(1);
      container.isFloat = false;
      appFloating.floatingSceneToFullAnimation(container, new SCBScreenProperty());
      expect(container.isFloat).assertFalse();
    })

    it('floatingSceneToFullAnimation_test_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      container.floatingParam.minAnimationNum = 3;
      container.needRenderScale.setScaleX(0);
      container.needRenderScale.setScaleY(1);
      container.isFloat = false;
      appFloating.floatingSceneToFullAnimation(container, new SCBScreenProperty());
      expect(container.isFloat).assertFalse();
    })

    it('floatingSceneToFullAnimation_test_03', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      container.floatingParam.minAnimationNum = 3;
      container.needRenderScale.setScaleX(1);
      container.needRenderScale.setScaleY(0);
      container.isFloat = false;
      appFloating.floatingSceneToFullAnimation(container, new SCBScreenProperty());
      expect(container.isFloat).assertFalse();
    })

    it('floatingSceneToFullAnimation_test_04', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      container.floatingParam.minAnimationNum = 3;
      container.needRenderScale.setScaleX(0);
      container.needRenderScale.setScaleY(0);
      container.isFloat = false;
      appFloating.floatingSceneToFullAnimation(container, new SCBScreenProperty());
      expect(container.isFloat).assertFalse();
    })

    it('floatingSceneToFullAnimation_test_05', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      container.floatingParam.minAnimationNum = 3;
      container.needRenderScale.setScaleX(1);
      container.needRenderScale.setScaleY(1);
      container.isFloat = true;
      appFloating.floatingSceneToFullAnimation(container, new SCBScreenProperty());
      expect(container.isFloat).assertTrue();
    })

    it('floatingSceneToFullAnimation_test_06', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let sceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
      (sceneSession as object)['setIsActive'](true);
      let container: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
      container.floatingParam.minAnimationNum = 3;
      container.needRenderScale.setScaleX(1);
      container.needRenderScale.setScaleY(1);
      container.isFloat = true;
      appFloating.floatingSceneToFullAnimation(container, new SCBScreenProperty(), () => {});
      expect(container.isFloat).assertTrue();
    })

    it('floatingSceneToFullAnimation_test_07', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let sceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
      (sceneSession as object)['setIsActive'](false);
      let container: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
      container.floatingParam.minAnimationNum = 3;
      container.needRenderScale.setScaleX(1);
      container.needRenderScale.setScaleY(1);
      container.isFloat = true;
      appFloating.floatingSceneToFullAnimation(container, new SCBScreenProperty(), () => {});
      expect(container.isFloat).assertTrue();
    })

    it('floatingSceneToFullAnimation_test_08', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let sceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
      (sceneSession as object)['setIsActive'](true);
      let container: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
      container.floatingParam.minAnimationNum = 3;
      container.needRenderScale.setScaleX(1);
      container.needRenderScale.setScaleY(1);
      container.isFloat = true;
      appFloating.floatingSceneToFullAnimation(container, new SCBScreenProperty());
      expect(container.isFloat).assertTrue();
    })

    it('floatingSceneToFullAnimation_test_09', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let sceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
      (sceneSession as object)['setIsActive'](false);
      let container: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
      container.floatingParam.minAnimationNum = 3;
      container.needRenderScale.setScaleX(1);
      container.needRenderScale.setScaleY(1);
      container.isFloat = true;
      appFloating.floatingSceneToFullAnimation(container, new SCBScreenProperty());
      expect(container.isFloat).assertTrue();
    })

    it('resizeSceneContainer_test', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      container.needRenderPos.setPosX(1);
      container.needRenderPos.setPosY(1);
      container.floatingParam.scale = 2;
      appFloating.resizeSceneContainer(container);
      expect(container.needRenderPos.posX).assertEqual(0);
    })

    it('floatingDragToFullAnimation_test', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      appFloating.floatingDragToFullAnimation(container, new SCBScreenProperty());
      expect(appFloating).not().assertUndefined();
    })

    it('resizeSceneContainerOnDrag_test', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      appFloating.resizeSceneContainerOnDrag(container);
      expect(appFloating).not().assertUndefined();
    })

    it('freezeBlur_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      appFloating.freezeBlur(container);
      expect(container.dividerParam.primary.blurScale).assertEqual(0.5);
    })

    it('freezeBlurByDrag_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      appFloating.freezeBlurByDrag(container);
      expect(container.floatingParam.effectCompOpacity).assertEqual(1);
    })
  });
}
