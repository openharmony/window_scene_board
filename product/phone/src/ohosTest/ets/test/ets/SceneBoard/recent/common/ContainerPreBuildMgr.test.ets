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
  PreBuildStage,
  SCBSceneInfo,
  SCBSceneSession,
  SCBScreenProperty } from '@ohos/windowscene';
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
  when,
  ArgumentMatchers
} from '@ohos/hypium';
import { ContainerBuilder, ContainerBuilderConfig } from '@ohos/phonebase/src/main/ets/SceneBoard/recent/common/ContainerBuild';
import { recentLayoutConfigInstance } from '@ohos/recents';
import sceneSessionManager from '@ohos.sceneSessionManager';

export default function ContainerPreBuildMgrTest() {
  describe('ContainerPreBuildMgrTest', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    let recentLayoutConfig = recentLayoutConfigInstance;
    let containerBuilderConfig: ContainerBuilderConfig = new ContainerBuilderConfig();
    let scbSceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
    let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
    let container: SCBSceneContainerSession = new SCBSceneContainerSession(scbSceneSession, new SCBScreenProperty());
    const TAG = 'ContainerPreBuildMgrTest';
    it('ContainerBuilderConfig_position_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let position: Position = {
        x: 0,
        y: 0,
      };
      containerBuilderConfig.resetPosition(position);
      expect(containerBuilderConfig.position).assertEqual(undefined);
    })

    it('ContainerBuilderConfig_position_test_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let position: Position = {
        x: 0,
        y: 0,
      };
      containerBuilderConfig._position = position;
      expect(containerBuilderConfig.position).assertEqual(position);
    })

    it('ContainerBuilderConfig_translate_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      containerBuilderConfig.resetTranslate();
      expect(containerBuilderConfig.translate).assertEqual(undefined);
    })

    it('ContainerBuilderConfig_translate_test_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let translate: TranslateOptions = {
        x: 0,
        y: 0,
      };
      containerBuilderConfig._translate = translate;
      expect(containerBuilderConfig.translate).assertEqual(translate);
    })

    it('ContainerBuilderConfig_scale_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let scale: ScaleOptions = {
        x: 0,
        y: 0,
      };
      containerBuilderConfig.resetScale(scale);
      expect(containerBuilderConfig.scale).assertEqual(undefined);
    })

    it('ContainerBuilderConfig_scale_test_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let scale: ScaleOptions = {
        x: 0,
        y: 0,
      };
      containerBuilderConfig._scale = scale;
      expect(containerBuilderConfig.scale).assertEqual(scale);
    })

    it('ContainerBuilderConfig_borderRadius_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      containerBuilderConfig.resetBorderRadius(0);
      expect(containerBuilderConfig.borderRadius).assertEqual(undefined);
    })

    it('ContainerBuilderConfig_borderRadius_test_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let borderRadius: number = 0;
      containerBuilderConfig.setBorderRadius(borderRadius);
      expect(containerBuilderConfig.borderRadius).assertEqual(borderRadius);
    })

    it('ContainerBuilderConfig_alpha_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      containerBuilderConfig.resetAlpha(0);
      expect(containerBuilderConfig.alpha).assertEqual(undefined);
    })

    it('ContainerBuilderConfig_alpha_test_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let alpha: number = 0;
      containerBuilderConfig.setAlpha(alpha);
      expect(containerBuilderConfig.alpha).assertEqual(alpha);
    })

    it('ContainerBuilderConfig_setVisibility_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let visibility: boolean = true;
      containerBuilderConfig.setVisibility(visibility);
      expect(containerBuilderConfig.visibility).assertEqual(visibility);
    })

    it('ContainerBuilderConfig_setVisibility_test_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let visibility: boolean = false;
      containerBuilderConfig.setVisibility(visibility);
      expect(containerBuilderConfig.visibility).assertEqual(visibility);
    })

    // ContainerBuilder
    it('ContainerBuilder_tryPreBuildContainer_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      container.needPreBuild.setPreBuildStage(PreBuildStage.NOT_PRE_BUILD);
      ContainerBuilder.tryPreBuildContainer(container, containerBuilderConfig);
      expect(container).not().assertUndefined();
    })

    it('ContainerBuilder_tryPreBuildContainer_test_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      container.needPreBuild.setPreBuildStage(PreBuildStage.PRE_BUILD_TITLE);
      ContainerBuilder.tryPreBuildContainer(container, containerBuilderConfig);
      expect(container).not().assertUndefined();
    })

    it('ContainerBuilder_tryPreBuildContainer_test_03', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      container.needPreBuild.setPreBuildStage(PreBuildStage.PRE_BUILD_SCENE);
      ContainerBuilder.tryPreBuildContainer(container, containerBuilderConfig);
      expect(container).not().assertUndefined();
    })

    it('ContainerBuilder_buildTitle_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      container.needRenderShowRecentTitle.setShowRecentTitle(true);
      container.needPreBuild.setPreBuildStage(PreBuildStage.PRE_BUILD_TITLE);
      ContainerBuilder.buildTitle(container);
      expect(container).not().assertUndefined();
    })

    it('ContainerBuilder_buildTitle_test_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      container.needRenderShowRecentTitle.setShowRecentTitle(true);
      container.needPreBuild.setPreBuildStage(PreBuildStage.PRE_BUILD_SCENE);
      ContainerBuilder.buildTitle(container);
      expect(container).not().assertUndefined();
    })

    it('ContainerBuilder_buildTitle_test_03', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      container.needRenderShowRecentTitle.setShowRecentTitle(true);
      container.needPreBuild.setPreBuildStage(PreBuildStage.NOT_PRE_BUILD);
      ContainerBuilder.buildTitle(container);
      expect(container).not().assertUndefined();
    })

    it('ContainerBuilder_buildTitle_test_04', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      container.needRenderShowRecentTitle.setShowRecentTitle(false);
      ContainerBuilder.buildTitle(container);
      expect(container).not().assertUndefined();
    })

    it('ContainerBuilder_buildScene_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let scale: ScaleOptions = {
        x: 0,
        y: 0,
      };
      container.needRenderShowInRecent.setShowInRecentWithDfx(true, TAG, 'buildScene_test');
      containerBuilderConfig.setScale(scale);
      container.needRenderScale.setScaleX(scale.x);
      ContainerBuilder.buildScene(container, containerBuilderConfig);
      expect(containerBuilderConfig._scale?.x).assertEqual(0);
    })

    it('ContainerBuilder_buildScene_isFloat_true', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      container.isFloat = true;
      let scale: ScaleOptions = {
        x: 0,
        y: 0,
      };
      container.needRenderShowInRecent.setShowInRecentWithDfx(true, TAG, 'buildScene_test');
      containerBuilderConfig.setScale(scale);
      container.needRenderScale.setScaleX(scale.x);
      ContainerBuilder.buildScene(container, containerBuilderConfig);
      expect(containerBuilderConfig._scale?.x).assertEqual(0);
    })

    it('ContainerBuilder_buildScene_test_05', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let scale: ScaleOptions = {
        x: 0,
        y: 0,
      };
      let position: Position = {
        x: 0,
        y: 0,
      };
      let translate: TranslateOptions = {
        x: 0,
        y: 0,
      };
      container.needRenderShowInRecent.setShowInRecentWithDfx(false, TAG, 'buildScene_test');
      containerBuilderConfig.resetScale(scale);
      container.needRenderScale.setScaleX(1);
      containerBuilderConfig.resetPosition(position);
      containerBuilderConfig.resetTranslate();
      container.isFloat = true;
      ContainerBuilder.buildScene(container, containerBuilderConfig);
      expect(container).not().assertUndefined();
    })

    it('ContainerBuilder_buildScene_test_06', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let scale: ScaleOptions = {
        x: 0,
        y: 0,
      };
      let position: Position = {
        x: 0,
        y: 0,
      };
      let translate: TranslateOptions = {
        x: 0,
        y: 0,
      };
      container.needRenderShowInRecent.setShowInRecentWithDfx(false, TAG, 'buildScene_test');
      containerBuilderConfig.resetScale(scale);
      container.needRenderScale.setScaleX(1);
      containerBuilderConfig.resetPosition(position);
      containerBuilderConfig.resetTranslate();
      container.isFloat = false;
      ContainerBuilder.buildScene(container, containerBuilderConfig);
      expect(container).not().assertUndefined();
    })

    it('ContainerBuilder_buildScene_test_07', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let scale: ScaleOptions = {
        x: 0,
        y: 0,
      };
      let position: Position = {
        x: 0,
        y: 0,
      };
      let translate: TranslateOptions = {
        x: 0,
        y: 0,
      };
      container.needRenderShowInRecent.setShowInRecentWithDfx(false, TAG, 'buildScene_test');
      containerBuilderConfig.setScale(scale);
      container.needRenderScale.setScaleX(1);
      containerBuilderConfig.setPosition(position);
      containerBuilderConfig.setTranslate(translate);
      containerBuilderConfig.setBorderRadius(0);
      containerBuilderConfig.setVisibility(true);
      containerBuilderConfig.setAlpha(0);
      container.requestActivationByCall(false);
      ContainerBuilder.buildScene(container, containerBuilderConfig);
      expect(containerBuilderConfig._position?.x).assertEqual(0);
    })

    it('ContainerBuilder_buildScene_test_08', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let scale: ScaleOptions = {
        x: 0,
        y: 0,
      };
      let position: Position = {
        x: 0,
        y: 0,
      };
      let translate: TranslateOptions = {
        x: 0,
        y: 0,
      };
      container.needRenderShowInRecent.setShowInRecentWithDfx(false, TAG, 'buildScene_test');
      containerBuilderConfig.setScale(scale);
      container.needRenderScale.setScaleX(1);
      containerBuilderConfig.setPosition(position);
      containerBuilderConfig.setTranslate(translate);
      containerBuilderConfig.resetBorderRadius(0);
      containerBuilderConfig.resetVisibility();
      containerBuilderConfig.resetAlpha(0);
      container.requestActivationByCall(true);
      ContainerBuilder.buildScene(container, containerBuilderConfig);
      expect(containerBuilderConfig._position?.x).assertEqual(0);
    })

    it('ContainerBuilder_destroyScene_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      container.needRenderShowInRecent.setShowInRecentWithDfx(false, TAG, 'destroyScene_test');
      ContainerBuilder.destroyScene(container);
      expect(container).not().assertUndefined();
    })

    it('ContainerBuilder_destroyScene_test_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      container.needRenderShowInRecent.setShowInRecentWithDfx(true, TAG, 'destroyScene_test');
      ContainerBuilder.destroyScene(container);
      expect(container).not().assertUndefined();
    })

    it('ContainerBuilder_preBuildScene2_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      container.needPreBuild.setPreBuildStage(PreBuildStage.PRE_BUILD_SCENE);
      container.requestActivationByCall(false);
      ContainerBuilder.tryPreBuildContainer(container, containerBuilderConfig);
      expect(container).not().assertUndefined();
    })

    it('ContainerBuilder_preBuildScene2_test_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      container.needPreBuild.setPreBuildStage(PreBuildStage.PRE_BUILD_SCENE2);
      container.requestActivationByCall(true);
      ContainerBuilder.tryPreBuildContainer(container, containerBuilderConfig);
      expect(container).not().assertUndefined();
    })

    it('preBuildScene2_test_equal_PRE_BUILD_SCENE2', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      container.needPreBuild.setPreBuildStage(PreBuildStage.PRE_BUILD_SCENE2);
      (ContainerBuilder as object)['preBuildScene2'](container, containerBuilderConfig, false);
      expect(container).not().assertUndefined();
    })

    it('preBuildScene2_test_large_PRE_BUILD_SCENE2', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      container.needPreBuild.setPreBuildStage(PreBuildStage.PRE_BUILD_DONE);
      (ContainerBuilder as object)['preBuildScene2'](container, containerBuilderConfig, false);
      expect(container).not().assertUndefined();
    })

    it('preBuildScene2_test_less_PRE_BUILD_SCENE2_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      container.requestActivationByCall(false);
      container.needPreBuild.setPreBuildStage(PreBuildStage.NOT_PRE_BUILD);
      (ContainerBuilder as object)['preBuildScene2'](container, containerBuilderConfig, true);
      expect(container).not().assertUndefined();
    })

    it('preBuildScene2_test_less_PRE_BUILD_SCENE2_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      container.requestActivationByCall(true);
      container.needPreBuild.setPreBuildStage(PreBuildStage.NOT_PRE_BUILD);
      (ContainerBuilder as object)['preBuildScene2'](container, containerBuilderConfig, true);
      expect(container).not().assertUndefined();
    })

    it('resetAllContainerPreBuildStage_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let list: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      container.needRenderShowInRecent.setShowInRecentWithDfx(true, 'resetAllContainerPreBuildStage', 'resetAllContainerPreBuildStage_test_02');
      list.add(container);
      ContainerBuilder.resetAllContainerPreBuildStage(list);
      expect(container.needPreBuild.preBuildStage).assertEqual(4);
    })

    it('resetAllContainerPreBuildStage_test_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let list: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      container.needRenderShowInRecent.setShowInRecentWithDfx(false, 'resetAllContainerPreBuildStage', 'resetAllContainerPreBuildStage_test_03');
      list.add(container);
      ContainerBuilder.resetAllContainerPreBuildStage(list);
      expect(container.needPreBuild.preBuildStage).assertEqual(0);
    })

    it('tryBuildContainer_test_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      ContainerBuilder.tryBuildContainer(container, containerBuilderConfig);
      expect(ContainerBuilder).not().assertUndefined();
    })

    it('tryBuildContainer_test_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      ContainerBuilder.tryDestroyContainer(container);
      expect(ContainerBuilder).not().assertUndefined();
    })

    it('preBuildTitle_equal_PRE_BUILD_TITLE', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      container.needPreBuild.setPreBuildStage(PreBuildStage.PRE_BUILD_TITLE);
      (ContainerBuilder as object)['preBuildTitle'](container, false);
      expect(container).not().assertUndefined();
    })

    it('preBuildTitle_large_PRE_BUILD_TITLE_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      container.needPreBuild.setPreBuildStage(PreBuildStage.PRE_BUILD_SCENE);
      (ContainerBuilder as object)['preBuildTitle'](container, false);
      expect(container).not().assertUndefined();
    })

    it('preBuildTitle_large_PRE_BUILD_TITLE_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      container.needPreBuild.setPreBuildStage(PreBuildStage.PRE_BUILD_SCENE2);
      (ContainerBuilder as object)['preBuildTitle'](container, false);
      expect(container).not().assertUndefined();
    })

    it('preBuildTitle_large_PRE_BUILD_TITLE_03', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      container.needPreBuild.setPreBuildStage(PreBuildStage.PRE_BUILD_DONE);
      (ContainerBuilder as object)['preBuildTitle'](container, false);
      expect(container).not().assertUndefined();
    })

    it('preBuildTitle_less_PRE_BUILD_TITLE_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      container.needPreBuild.setPreBuildStage(PreBuildStage.NOT_PRE_BUILD);
      (ContainerBuilder as object)['preBuildTitle'](container, false);
      expect(container).not().assertUndefined();
    })

    it('preBuildTitle_less_PRE_BUILD_TITLE_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      container.needPreBuild.setPreBuildStage(PreBuildStage.NOT_PRE_BUILD);
      (ContainerBuilder as object)['preBuildTitle'](container, true);
      expect(container).not().assertUndefined();
    })

    it('showTitle_not_null', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      ContainerBuilder.showTitle(container);
      expect(ContainerBuilder).not().assertUndefined();
    })

    it('destroyTitle_not_null', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      ContainerBuilder.destroyTitle(container);
      expect(ContainerBuilder).not().assertUndefined();
    })

    it('hideTitle_not_null', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      ContainerBuilder.hideTitle(container);
      expect(ContainerBuilder).not().assertUndefined();
    })

    it('preBuildScene_large_PRE_BUILD_SCENE_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      container.needPreBuild.setPreBuildStage(PreBuildStage.PRE_BUILD_SCENE2);
      (ContainerBuilder as object)['preBuildScene'](container, containerBuilderConfig, false);
      expect(container).not().assertUndefined();
    })

    it('preBuildScene_large_PRE_BUILD_SCENE_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      container.needPreBuild.setPreBuildStage(PreBuildStage.PRE_BUILD_DONE);
      (ContainerBuilder as object)['preBuildScene'](container, containerBuilderConfig, false);
      expect(container).not().assertUndefined();
    })

    it('preBuildScene_equal_PRE_BUILD_SCENE', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      container.needPreBuild.setPreBuildStage(PreBuildStage.PRE_BUILD_SCENE);
      (ContainerBuilder as object)['preBuildScene'](container, containerBuilderConfig, false);
      expect(container).not().assertUndefined();
    })

    it('preBuildScene_less_PRE_BUILD_SCENE_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      container.needPreBuild.setPreBuildStage(PreBuildStage.NOT_PRE_BUILD);
      (ContainerBuilder as object)['preBuildScene'](container, containerBuilderConfig, true);
      expect(container).not().assertUndefined();
    })

    it('preBuildScene_less_PRE_BUILD_SCENE_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      container.needPreBuild.setPreBuildStage(PreBuildStage.PRE_BUILD_TITLE);
      (ContainerBuilder as object)['preBuildScene'](container, containerBuilderConfig, false);
      expect(container).not().assertUndefined();
    })

    it('preBuildScene_isNeedMultiRowLayout_false', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let position: Position = {
        x: 0,
        y: 0,
      };
      let translate: TranslateOptions = {
        x: 0,
        y: 0,
      };
      containerBuilderConfig._translate = translate;
      containerBuilderConfig._position = position;
      containerBuilderConfig._borderRadius = 0;15
      container.needPreBuild.setPreBuildStage(PreBuildStage.NOT_PRE_BUILD);
      let mocker: MockKit = new MockKit();
      let isNeedMultiRouLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRouLayout)().afterReturn(false);
      (ContainerBuilder as object)['preBuildScene'](container, containerBuilderConfig, false);
      expect(containerBuilderConfig._translate.x).assertEqual(0);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('preBuildScene_isNeedMultiRowLayout_true_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      container.isFloat = true;
      let scale: ScaleOptions = {
        x: 0,
        y: 0,
      };
      containerBuilderConfig._scale = scale;
      container.needPreBuild.setPreBuildStage(PreBuildStage.NOT_PRE_BUILD);
      let mocker: MockKit = new MockKit();
      let isNeedMultiRouLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRouLayout)().afterReturn(true);
      (ContainerBuilder as object)['preBuildScene'](container, containerBuilderConfig, false);
      expect(containerBuilderConfig._scale.x).assertEqual(0);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('preBuildScene_isNeedMultiRowLayout_true_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      container.isFloat = false;
      let scale: ScaleOptions = {
        x: 0,
        y: 0,
      };
      containerBuilderConfig._scale = scale;
      container.needPreBuild.setPreBuildStage(PreBuildStage.NOT_PRE_BUILD);
      let mocker: MockKit = new MockKit();
      let isNeedMultiRouLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRouLayout)().afterReturn(true);
      (ContainerBuilder as object)['preBuildScene'](container, containerBuilderConfig, false);
      expect(containerBuilderConfig._scale.x).assertEqual(0);
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('restoreScene_not_null', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      ContainerBuilder.restoreScene(container);
      expect(ContainerBuilder).not().assertUndefined();
    })
  })
}