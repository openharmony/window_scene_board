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
  NeedRenderPos,
  NeedRenderScale,
  SCBDividerParam,
  SCBSceneContainerSession,
  SCBSceneContainerSessionArray,
  SCBSceneInfo,
  SCBSceneSession,
  SCBScreenProperty} from '@ohos/windowscene';
import { CheckEmptyUtils } from '@ohos/basicutils';
import { commonBundleManager, DeviceHelper, IconResourceManager, ResourceManager } from '@ohos/frameworkwrapper';
import { AppItemInfo, AppModel, launcherAbilityManager, RecentMissionsModel } from '@ohos/launchercommon';

import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect, TestType, Size, Level,
  MockKit,
  when,
  ArgumentMatchers} from '@ohos/hypium';
import { RecentTitleInfo, RecentTitleViewModel } from '@ohos/phonebase/src/main/ets/SceneBoard/recent/viewmodel/RecentTitleViewModel';
import bundleManager from '@ohos.bundle.bundleManager';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { common } from '@kit.AbilityKit';
import { VassistantConstants } from '@ohos/commonconstants';
import { recentRuntimeInstance } from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/recentpanel/RecentRuntimeModel';

export default function RecentTitleViewModelTest() {
  describe('RecentTitleViewModelTest', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    let appModel: AppModel = AppModel.getInstance();
    let resourceManager: ResourceManager = ResourceManager.getInstance();
    let recentMissionsModel: RecentMissionsModel = RecentMissionsModel.getInstance();
    let sceneAppInfo: AppItemInfo = new AppItemInfo();
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    let session: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let property: SCBScreenProperty = new SCBScreenProperty();
    let sceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(session, property);
    let scale: NeedRenderScale = new NeedRenderScale();
    let pos: NeedRenderPos = new NeedRenderPos();
    let uiAbilityContext = getContext() as common.UIAbilityContext;
    let appItemInfo: bundleManager.AbilityInfo = uiAbilityContext && uiAbilityContext.abilityInfo || {} as bundleManager.AbilityInfo;
    let iconResourceManager: IconResourceManager = IconResourceManager.getInstance();
    let icon: Resource = {
      bundleName: 'bundleName',
      moduleName: 'moduleName',
      id: 0
    };
    let primaryRecentTitleInfo: RecentTitleInfo = new RecentTitleInfo();
    let secondaryRecentTitleInfo: RecentTitleInfo = new RecentTitleInfo();
    primaryRecentTitleInfo.setAppInfo(sceneAppInfo);
    primaryRecentTitleInfo.setIcon(icon);
    primaryRecentTitleInfo.setName('test');
    let recentTitleViewModel:RecentTitleViewModel = new RecentTitleViewModel(property,primaryRecentTitleInfo,secondaryRecentTitleInfo);
    recentTitleViewModel.primaryRecentTitleInfo = primaryRecentTitleInfo;
    recentTitleViewModel.secondaryRecentTitleInfo = primaryRecentTitleInfo;
    let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
    let scbSceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
    let primarySession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
    totalContainerSessionList.add(new SCBSceneContainerSession(primarySession, new SCBScreenProperty()));
    totalContainerSessionList.add(new SCBSceneContainerSession(primarySession, new SCBScreenProperty()));
    let scbSceneContainer: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, new SCBScreenProperty());

    it('getRecentAppInfo_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      expect(RecentTitleViewModel.getRecentAppInfo(sceneInfo)).not().assertUndefined();
    })

    it('getRecentAppInfo_test_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      expect(RecentTitleViewModel.getRecentAppInfo(undefined)).not().assertUndefined();
    })

    it('getRecentAppInfo_test_03', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let appInfoFromCache: AppItemInfo | undefined = new AppItemInfo();
      appInfoFromCache.appIconId = 0;
      appInfoFromCache.appLabelId = 0;
      let mocker: MockKit = new MockKit();
      let getAppInfoMockFunc: Function = mocker.mockFunc(appModel,
        appModel.getAppInfoByBundleNameAndAbility);
      when(getAppInfoMockFunc)(ArgumentMatchers.any).afterReturn(appInfoFromCache);
      expect(RecentTitleViewModel.getRecentAppInfo(sceneInfo)).not().assertUndefined();
      mocker.ignoreMock(appModel,
        appModel.getAppInfoByBundleNameAndAbility);
    })

    it('getRecentAppInfo_test_04', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let appInfoFromCache: AppItemInfo | undefined = new AppItemInfo();
      appInfoFromCache.appIconId = 0;
      appInfoFromCache.appLabelId = 1;
      let mocker: MockKit = new MockKit();
      let getAppInfoMockFunc: Function = mocker.mockFunc(appModel, appModel.getAppInfoByBundleNameAndAbility);
      when(getAppInfoMockFunc)(ArgumentMatchers.any).afterReturn(appInfoFromCache);
      expect(RecentTitleViewModel.getRecentAppInfo(sceneInfo)).not().assertUndefined();
      mocker.ignoreMock(appModel,
        appModel.getAppInfoByBundleNameAndAbility);
    })

    it('getRecentAppInfo_test_05', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let appInfoFromCache: AppItemInfo | undefined = new AppItemInfo();
      appInfoFromCache.appIconId = 1;
      appInfoFromCache.appLabelId = 1;
      let mocker: MockKit = new MockKit();
      let getAppInfoMockFunc: Function = mocker.mockFunc(appModel, appModel.getAppInfoByBundleNameAndAbility);
      when(getAppInfoMockFunc)(ArgumentMatchers.any).afterReturn(appInfoFromCache);
      expect(RecentTitleViewModel.getRecentAppInfo(sceneInfo)).not().assertUndefined();
      mocker.ignoreMock(appModel,
        appModel.getAppInfoByBundleNameAndAbility);
    })

    it('getRecentAppInfo_test_06', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(appModel, appModel.getAppInfoByBundleNameAndAbility);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunc2: Function = mocker.mockFunc(commonBundleManager, commonBundleManager.getAbilityInfoByAbilityName);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(undefined);
      expect(RecentTitleViewModel.getRecentAppInfo(sceneInfo)).not().assertUndefined();
      mocker.ignoreMock(appModel, appModel.getAppInfoByBundleNameAndAbility);
      mocker.ignoreMock(commonBundleManager, commonBundleManager.getAbilityInfoByAbilityName);
    })

    it('getRecentAppInfo_test_09', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(appModel, appModel.getAppInfoByBundleNameAndAbility);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunc2: Function = mocker.mockFunc(commonBundleManager, commonBundleManager.getAbilityInfoByAbilityName);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunc3: Function = mocker.mockFunc(resourceManager, resourceManager.isSCBInnerModule);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(true);
      expect(RecentTitleViewModel.getRecentAppInfo(sceneInfo)).not().assertUndefined();
      mocker.ignoreMock(appModel, appModel.getAppInfoByBundleNameAndAbility);
      mocker.ignoreMock(commonBundleManager, commonBundleManager.getAbilityInfoByAbilityName);
      mocker.ignoreMock(resourceManager, resourceManager.isSCBInnerModule);
    })

    it('getRecentAppInfo_test_10', TestType.USER | Size.SMALLTEST | Level.LEVEL0, async (): Promise<void> => {
      let appInfoFromCache: AppItemInfo | undefined = new AppItemInfo();
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(appModel, appModel.getAppInfoByBundleNameAndAbility);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(appInfoFromCache);
      appInfoFromCache = undefined;
      let mockFunc2: Function = mocker.mockFunc(commonBundleManager, commonBundleManager.getAbilityInfoByAbilityName);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunc3: Function = mocker.mockFunc(resourceManager, resourceManager.isSCBInnerModule);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);
      let mockFunc4: Function = mocker.mockFunc(recentMissionsModel, recentMissionsModel.getHapAbilityInfoAsync);
      when(mockFunc4)(ArgumentMatchers.any).afterReturn(undefined);
      expect(RecentTitleViewModel.getRecentAppInfo(sceneInfo)).not().assertUndefined();
      mocker.ignoreMock(appModel, appModel.getAppInfoByBundleNameAndAbility);
      mocker.ignoreMock(commonBundleManager, commonBundleManager.getAbilityInfoByAbilityName);
      mocker.ignoreMock(resourceManager, resourceManager.isSCBInnerModule);
      mocker.ignoreMock(recentMissionsModel, recentMissionsModel.getHapAbilityInfoAsync);
    })

    it('getRecentAppInfo_test_11', TestType.USER | Size.SMALLTEST | Level.LEVEL0, async (): Promise<void> => {
      let appInfoFromCache: AppItemInfo | undefined = new AppItemInfo();
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(appModel, appModel.getAppInfoByBundleNameAndAbility);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(appInfoFromCache);
      let mockFunc2: Function = mocker.mockFunc(commonBundleManager, commonBundleManager.getAbilityInfoByAbilityName);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(appItemInfo);
      expect(RecentTitleViewModel.getRecentAppInfo(sceneInfo)).not().assertUndefined();
      mocker.ignoreMock(appModel, appModel.getAppInfoByBundleNameAndAbility);
      mocker.ignoreMock(commonBundleManager, commonBundleManager.getAbilityInfoByAbilityName);
    })

    it('getRecentAppInfo_test_12', TestType.USER | Size.SMALLTEST | Level.LEVEL0, async (): Promise<void> => {
      let appInfoFromCache: AppItemInfo | undefined = new AppItemInfo();
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(appModel, appModel.getAppInfoByBundleNameAndAbility);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(appInfoFromCache);
      let mockFunc2: Function = mocker.mockFunc(commonBundleManager, commonBundleManager.getAbilityInfoByAbilityName);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunc3: Function = mocker.mockFunc(resourceManager, resourceManager.isSCBInnerModule);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(true);
      let mockFunc4: Function = mocker.mockFunc(recentMissionsModel, recentMissionsModel.getHapAbilityInfoAsync);
      when(mockFunc4)(ArgumentMatchers.any).afterReturn(undefined);
      expect(RecentTitleViewModel.getRecentAppInfo(sceneInfo)).not().assertUndefined();
      mocker.ignoreMock(appModel, appModel.getAppInfoByBundleNameAndAbility);
      mocker.ignoreMock(commonBundleManager, commonBundleManager.getAbilityInfoByAbilityName);
      mocker.ignoreMock(resourceManager, resourceManager.isSCBInnerModule);
      mocker.ignoreMock(recentMissionsModel, recentMissionsModel.getHapAbilityInfoAsync);
    })

    it('getRecentAppInfo_test_13', TestType.USER | Size.SMALLTEST | Level.LEVEL0, async (): Promise<void> => {
      let appInfoFromCache: AppItemInfo | undefined = new AppItemInfo();
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(appModel, appModel.getAppInfoByBundleNameAndAbility);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(appInfoFromCache);
      let mockFunc2: Function = mocker.mockFunc(commonBundleManager, commonBundleManager.getAbilityInfoByAbilityName);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunc3: Function = mocker.mockFunc(resourceManager, resourceManager.isSCBInnerModule);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);
      let mockFunc4: Function = mocker.mockFunc(recentMissionsModel, recentMissionsModel.getHapAbilityInfoAsync);
      when(mockFunc4)(ArgumentMatchers.any).afterReturn(appItemInfo);
      expect(RecentTitleViewModel.getRecentAppInfo(sceneInfo)).not().assertUndefined();
      mocker.ignoreMock(appModel, appModel.getAppInfoByBundleNameAndAbility);
      mocker.ignoreMock(commonBundleManager, commonBundleManager.getAbilityInfoByAbilityName);
      mocker.ignoreMock(resourceManager, resourceManager.isSCBInnerModule);
      mocker.ignoreMock(recentMissionsModel, recentMissionsModel.getHapAbilityInfoAsync);
    })

    it('getRecentAppInfo_test_14', TestType.USER | Size.SMALLTEST | Level.LEVEL0, async (): Promise<void> => {
      let appInfoFromCache: AppItemInfo | undefined = new AppItemInfo();
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(appModel, appModel.getAppInfoByBundleNameAndAbility);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(appInfoFromCache);
      let mockFunc2: Function = mocker.mockFunc(commonBundleManager, commonBundleManager.getAbilityInfoByAbilityName);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunc3: Function = mocker.mockFunc(resourceManager, resourceManager.isSCBInnerModule);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);
      let mockFunc4: Function = mocker.mockFunc(recentMissionsModel, recentMissionsModel.getHapAbilityInfoAsync);
      when(mockFunc4)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunc5: Function = mocker.mockFunc(launcherAbilityManager, launcherAbilityManager.getAppLabelId);
      when(mockFunc5)(ArgumentMatchers.any).afterReturn(1);
      expect(RecentTitleViewModel.getRecentAppInfo(sceneInfo)).not().assertUndefined();
      mocker.ignoreMock(appModel, appModel.getAppInfoByBundleNameAndAbility);
      mocker.ignoreMock(commonBundleManager, commonBundleManager.getAbilityInfoByAbilityName);
      mocker.ignoreMock(resourceManager, resourceManager.isSCBInnerModule);
      mocker.ignoreMock(recentMissionsModel, recentMissionsModel.getHapAbilityInfoAsync);
      mocker.ignoreMock(launcherAbilityManager, launcherAbilityManager.getAppLabelId);
    })

    it('getRecentAppInfo_test_14_copy01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, async (): Promise<void> => {
      let appInfoFromCache: AppItemInfo | undefined = new AppItemInfo();
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(appModel, appModel.getAppInfoByBundleNameAndAbility);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(appInfoFromCache);
      let mockFunc2: Function = mocker.mockFunc(commonBundleManager, commonBundleManager.getAbilityInfoByAbilityName);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunc3: Function = mocker.mockFunc(resourceManager, resourceManager.isSCBInnerModule);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);
      let mockFunc4: Function = mocker.mockFunc(recentMissionsModel, recentMissionsModel.getHapAbilityInfoAsync);
      when(mockFunc4)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunc5: Function = mocker.mockFunc(launcherAbilityManager, launcherAbilityManager.getAppLabelId);
      when(mockFunc5)(ArgumentMatchers.any).afterReturn(1);
      expect(RecentTitleViewModel.getRecentAppInfo(sceneInfo)).not().assertUndefined();
      mocker.ignoreMock(appModel, appModel.getAppInfoByBundleNameAndAbility);
      mocker.ignoreMock(commonBundleManager, commonBundleManager.getAbilityInfoByAbilityName);
      mocker.ignoreMock(resourceManager, resourceManager.isSCBInnerModule);
      mocker.ignoreMock(recentMissionsModel, recentMissionsModel.getHapAbilityInfoAsync);
      mocker.ignoreMock(launcherAbilityManager, launcherAbilityManager.getAppLabelId);
    })

    it('getRecentAppInfo_test_14_copy02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, async (): Promise<void> => {
      let appInfoFromCache: AppItemInfo | undefined = new AppItemInfo();
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(appModel, appModel.getAppInfoByBundleNameAndAbility);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(appInfoFromCache);
      let mockFunc2: Function = mocker.mockFunc(commonBundleManager, commonBundleManager.getAbilityInfoByAbilityName);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunc3: Function = mocker.mockFunc(resourceManager, resourceManager.isSCBInnerModule);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);
      let mockFunc4: Function = mocker.mockFunc(recentMissionsModel, recentMissionsModel.getHapAbilityInfoAsync);
      when(mockFunc4)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunc5: Function = mocker.mockFunc(launcherAbilityManager, launcherAbilityManager.getAppLabelId);
      when(mockFunc5)(ArgumentMatchers.any).afterReturn(1);
      expect(RecentTitleViewModel.getRecentAppInfo(sceneInfo)).not().assertUndefined();
      mocker.ignoreMock(appModel, appModel.getAppInfoByBundleNameAndAbility);
      mocker.ignoreMock(commonBundleManager, commonBundleManager.getAbilityInfoByAbilityName);
      mocker.ignoreMock(resourceManager, resourceManager.isSCBInnerModule);
      mocker.ignoreMock(recentMissionsModel, recentMissionsModel.getHapAbilityInfoAsync);
      mocker.ignoreMock(launcherAbilityManager, launcherAbilityManager.getAppLabelId);
    })

    it('getRecentAppInfo_test_14_copy03', TestType.USER | Size.SMALLTEST | Level.LEVEL0, async (): Promise<void> => {
      let appInfoFromCache: AppItemInfo | undefined = new AppItemInfo();
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(appModel, appModel.getAppInfoByBundleNameAndAbility);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(appInfoFromCache);
      let mockFunc2: Function = mocker.mockFunc(commonBundleManager, commonBundleManager.getAbilityInfoByAbilityName);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunc3: Function = mocker.mockFunc(resourceManager, resourceManager.isSCBInnerModule);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);
      let mockFunc4: Function = mocker.mockFunc(recentMissionsModel, recentMissionsModel.getHapAbilityInfoAsync);
      when(mockFunc4)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunc5: Function = mocker.mockFunc(launcherAbilityManager, launcherAbilityManager.getAppLabelId);
      when(mockFunc5)(ArgumentMatchers.any).afterReturn(1);
      expect(RecentTitleViewModel.getRecentAppInfo(sceneInfo)).not().assertUndefined();
      mocker.ignoreMock(appModel, appModel.getAppInfoByBundleNameAndAbility);
      mocker.ignoreMock(commonBundleManager, commonBundleManager.getAbilityInfoByAbilityName);
      mocker.ignoreMock(resourceManager, resourceManager.isSCBInnerModule);
      mocker.ignoreMock(recentMissionsModel, recentMissionsModel.getHapAbilityInfoAsync);
      mocker.ignoreMock(launcherAbilityManager, launcherAbilityManager.getAppLabelId);
    })

    it('getRecentAppInfo_test_14_copy04', TestType.USER | Size.SMALLTEST | Level.LEVEL0, async (): Promise<void> => {
      let appInfoFromCache: AppItemInfo | undefined = new AppItemInfo();
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(appModel, appModel.getAppInfoByBundleNameAndAbility);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(appInfoFromCache);
      let mockFunc2: Function = mocker.mockFunc(commonBundleManager, commonBundleManager.getAbilityInfoByAbilityName);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunc3: Function = mocker.mockFunc(resourceManager, resourceManager.isSCBInnerModule);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);
      let mockFunc4: Function = mocker.mockFunc(recentMissionsModel, recentMissionsModel.getHapAbilityInfoAsync);
      when(mockFunc4)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunc5: Function = mocker.mockFunc(launcherAbilityManager, launcherAbilityManager.getAppLabelId);
      when(mockFunc5)(ArgumentMatchers.any).afterReturn(1);
      expect(RecentTitleViewModel.getRecentAppInfo(sceneInfo)).not().assertUndefined();
      mocker.ignoreMock(appModel, appModel.getAppInfoByBundleNameAndAbility);
      mocker.ignoreMock(commonBundleManager, commonBundleManager.getAbilityInfoByAbilityName);
      mocker.ignoreMock(resourceManager, resourceManager.isSCBInnerModule);
      mocker.ignoreMock(recentMissionsModel, recentMissionsModel.getHapAbilityInfoAsync);
      mocker.ignoreMock(launcherAbilityManager, launcherAbilityManager.getAppLabelId);
    })

    it('getRecentAppInfo_test_14_copy05', TestType.USER | Size.SMALLTEST | Level.LEVEL0, async (): Promise<void> => {
      let appInfoFromCache: AppItemInfo | undefined = new AppItemInfo();
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(appModel, appModel.getAppInfoByBundleNameAndAbility);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(appInfoFromCache);
      let mockFunc2: Function = mocker.mockFunc(commonBundleManager, commonBundleManager.getAbilityInfoByAbilityName);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunc3: Function = mocker.mockFunc(resourceManager, resourceManager.isSCBInnerModule);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);
      let mockFunc4: Function = mocker.mockFunc(recentMissionsModel, recentMissionsModel.getHapAbilityInfoAsync);
      when(mockFunc4)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunc5: Function = mocker.mockFunc(launcherAbilityManager, launcherAbilityManager.getAppLabelId);
      when(mockFunc5)(ArgumentMatchers.any).afterReturn(1);
      expect(RecentTitleViewModel.getRecentAppInfo(sceneInfo)).not().assertUndefined();
      mocker.ignoreMock(appModel, appModel.getAppInfoByBundleNameAndAbility);
      mocker.ignoreMock(commonBundleManager, commonBundleManager.getAbilityInfoByAbilityName);
      mocker.ignoreMock(resourceManager, resourceManager.isSCBInnerModule);
      mocker.ignoreMock(recentMissionsModel, recentMissionsModel.getHapAbilityInfoAsync);
      mocker.ignoreMock(launcherAbilityManager, launcherAbilityManager.getAppLabelId);
    })

    it('getRecentAppInfo_test_14_copy06', TestType.USER | Size.SMALLTEST | Level.LEVEL0, async (): Promise<void> => {
      let appInfoFromCache: AppItemInfo | undefined = new AppItemInfo();
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(appModel, appModel.getAppInfoByBundleNameAndAbility);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(appInfoFromCache);
      let mockFunc2: Function = mocker.mockFunc(commonBundleManager, commonBundleManager.getAbilityInfoByAbilityName);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunc3: Function = mocker.mockFunc(resourceManager, resourceManager.isSCBInnerModule);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);
      let mockFunc4: Function = mocker.mockFunc(recentMissionsModel, recentMissionsModel.getHapAbilityInfoAsync);
      when(mockFunc4)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunc5: Function = mocker.mockFunc(launcherAbilityManager, launcherAbilityManager.getAppLabelId);
      when(mockFunc5)(ArgumentMatchers.any).afterReturn(1);
      expect(RecentTitleViewModel.getRecentAppInfo(sceneInfo)).not().assertUndefined();
      mocker.ignoreMock(appModel, appModel.getAppInfoByBundleNameAndAbility);
      mocker.ignoreMock(commonBundleManager, commonBundleManager.getAbilityInfoByAbilityName);
      mocker.ignoreMock(resourceManager, resourceManager.isSCBInnerModule);
      mocker.ignoreMock(recentMissionsModel, recentMissionsModel.getHapAbilityInfoAsync);
      mocker.ignoreMock(launcherAbilityManager, launcherAbilityManager.getAppLabelId);
    })

    it('getRecentAppInfo_test_14_copy07', TestType.USER | Size.SMALLTEST | Level.LEVEL0, async (): Promise<void> => {
      let appInfoFromCache: AppItemInfo | undefined = new AppItemInfo();
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(appModel, appModel.getAppInfoByBundleNameAndAbility);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(appInfoFromCache);
      let mockFunc2: Function = mocker.mockFunc(commonBundleManager, commonBundleManager.getAbilityInfoByAbilityName);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunc3: Function = mocker.mockFunc(resourceManager, resourceManager.isSCBInnerModule);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);
      let mockFunc4: Function = mocker.mockFunc(recentMissionsModel, recentMissionsModel.getHapAbilityInfoAsync);
      when(mockFunc4)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunc5: Function = mocker.mockFunc(launcherAbilityManager, launcherAbilityManager.getAppLabelId);
      when(mockFunc5)(ArgumentMatchers.any).afterReturn(1);
      expect(RecentTitleViewModel.getRecentAppInfo(sceneInfo)).not().assertUndefined();
      mocker.ignoreMock(appModel, appModel.getAppInfoByBundleNameAndAbility);
      mocker.ignoreMock(commonBundleManager, commonBundleManager.getAbilityInfoByAbilityName);
      mocker.ignoreMock(resourceManager, resourceManager.isSCBInnerModule);
      mocker.ignoreMock(recentMissionsModel, recentMissionsModel.getHapAbilityInfoAsync);
      mocker.ignoreMock(launcherAbilityManager, launcherAbilityManager.getAppLabelId);
    })

    it('getRecentAppInfo_test_14_copy08', TestType.USER | Size.SMALLTEST | Level.LEVEL0, async (): Promise<void> => {
      let appInfoFromCache: AppItemInfo | undefined = new AppItemInfo();
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(appModel, appModel.getAppInfoByBundleNameAndAbility);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(appInfoFromCache);
      let mockFunc2: Function = mocker.mockFunc(commonBundleManager, commonBundleManager.getAbilityInfoByAbilityName);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunc3: Function = mocker.mockFunc(resourceManager, resourceManager.isSCBInnerModule);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);
      let mockFunc4: Function = mocker.mockFunc(recentMissionsModel, recentMissionsModel.getHapAbilityInfoAsync);
      when(mockFunc4)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunc5: Function = mocker.mockFunc(launcherAbilityManager, launcherAbilityManager.getAppLabelId);
      when(mockFunc5)(ArgumentMatchers.any).afterReturn(1);
      expect(RecentTitleViewModel.getRecentAppInfo(sceneInfo)).not().assertUndefined();
      mocker.ignoreMock(appModel, appModel.getAppInfoByBundleNameAndAbility);
      mocker.ignoreMock(commonBundleManager, commonBundleManager.getAbilityInfoByAbilityName);
      mocker.ignoreMock(resourceManager, resourceManager.isSCBInnerModule);
      mocker.ignoreMock(recentMissionsModel, recentMissionsModel.getHapAbilityInfoAsync);
      mocker.ignoreMock(launcherAbilityManager, launcherAbilityManager.getAppLabelId);
    })

    it('getRecentAppInfo_test_14_copy09', TestType.USER | Size.SMALLTEST | Level.LEVEL0, async (): Promise<void> => {
      let appInfoFromCache: AppItemInfo | undefined = new AppItemInfo();
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(appModel, appModel.getAppInfoByBundleNameAndAbility);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(appInfoFromCache);
      let mockFunc2: Function = mocker.mockFunc(commonBundleManager, commonBundleManager.getAbilityInfoByAbilityName);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunc3: Function = mocker.mockFunc(resourceManager, resourceManager.isSCBInnerModule);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);
      let mockFunc4: Function = mocker.mockFunc(recentMissionsModel, recentMissionsModel.getHapAbilityInfoAsync);
      when(mockFunc4)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunc5: Function = mocker.mockFunc(launcherAbilityManager, launcherAbilityManager.getAppLabelId);
      when(mockFunc5)(ArgumentMatchers.any).afterReturn(1);
      expect(RecentTitleViewModel.getRecentAppInfo(sceneInfo)).not().assertUndefined();
      mocker.ignoreMock(appModel, appModel.getAppInfoByBundleNameAndAbility);
      mocker.ignoreMock(commonBundleManager, commonBundleManager.getAbilityInfoByAbilityName);
      mocker.ignoreMock(resourceManager, resourceManager.isSCBInnerModule);
      mocker.ignoreMock(recentMissionsModel, recentMissionsModel.getHapAbilityInfoAsync);
      mocker.ignoreMock(launcherAbilityManager, launcherAbilityManager.getAppLabelId);
    })

    it('getRecentAppInfo_test_14_copy10', TestType.USER | Size.SMALLTEST | Level.LEVEL0, async (): Promise<void> => {
      let appInfoFromCache: AppItemInfo | undefined = new AppItemInfo();
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(appModel, appModel.getAppInfoByBundleNameAndAbility);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(appInfoFromCache);
      let mockFunc2: Function = mocker.mockFunc(commonBundleManager, commonBundleManager.getAbilityInfoByAbilityName);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunc3: Function = mocker.mockFunc(resourceManager, resourceManager.isSCBInnerModule);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);
      let mockFunc4: Function = mocker.mockFunc(recentMissionsModel, recentMissionsModel.getHapAbilityInfoAsync);
      when(mockFunc4)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunc5: Function = mocker.mockFunc(launcherAbilityManager, launcherAbilityManager.getAppLabelId);
      when(mockFunc5)(ArgumentMatchers.any).afterReturn(1);
      expect(RecentTitleViewModel.getRecentAppInfo(sceneInfo)).not().assertUndefined();
      mocker.ignoreMock(appModel, appModel.getAppInfoByBundleNameAndAbility);
      mocker.ignoreMock(commonBundleManager, commonBundleManager.getAbilityInfoByAbilityName);
      mocker.ignoreMock(resourceManager, resourceManager.isSCBInnerModule);
      mocker.ignoreMock(recentMissionsModel, recentMissionsModel.getHapAbilityInfoAsync);
      mocker.ignoreMock(launcherAbilityManager, launcherAbilityManager.getAppLabelId);
    })

    it('getRecentAppInfo_test_14_copy11', TestType.USER | Size.SMALLTEST | Level.LEVEL0, async (): Promise<void> => {
      let appInfoFromCache: AppItemInfo | undefined = new AppItemInfo();
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(appModel, appModel.getAppInfoByBundleNameAndAbility);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(appInfoFromCache);
      let mockFunc2: Function = mocker.mockFunc(commonBundleManager, commonBundleManager.getAbilityInfoByAbilityName);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunc3: Function = mocker.mockFunc(resourceManager, resourceManager.isSCBInnerModule);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);
      let mockFunc4: Function = mocker.mockFunc(recentMissionsModel, recentMissionsModel.getHapAbilityInfoAsync);
      when(mockFunc4)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunc5: Function = mocker.mockFunc(launcherAbilityManager, launcherAbilityManager.getAppLabelId);
      when(mockFunc5)(ArgumentMatchers.any).afterReturn(1);
      expect(RecentTitleViewModel.getRecentAppInfo(sceneInfo)).not().assertUndefined();
      mocker.ignoreMock(appModel, appModel.getAppInfoByBundleNameAndAbility);
      mocker.ignoreMock(commonBundleManager, commonBundleManager.getAbilityInfoByAbilityName);
      mocker.ignoreMock(resourceManager, resourceManager.isSCBInnerModule);
      mocker.ignoreMock(recentMissionsModel, recentMissionsModel.getHapAbilityInfoAsync);
      mocker.ignoreMock(launcherAbilityManager, launcherAbilityManager.getAppLabelId);
    })

    it('getRecentAppInfo_test_14_copy12', TestType.USER | Size.SMALLTEST | Level.LEVEL0, async (): Promise<void> => {
      let appInfoFromCache: AppItemInfo | undefined = new AppItemInfo();
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(appModel, appModel.getAppInfoByBundleNameAndAbility);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(appInfoFromCache);
      let mockFunc2: Function = mocker.mockFunc(commonBundleManager, commonBundleManager.getAbilityInfoByAbilityName);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunc3: Function = mocker.mockFunc(resourceManager, resourceManager.isSCBInnerModule);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);
      let mockFunc4: Function = mocker.mockFunc(recentMissionsModel, recentMissionsModel.getHapAbilityInfoAsync);
      when(mockFunc4)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunc5: Function = mocker.mockFunc(launcherAbilityManager, launcherAbilityManager.getAppLabelId);
      when(mockFunc5)(ArgumentMatchers.any).afterReturn(1);
      expect(RecentTitleViewModel.getRecentAppInfo(sceneInfo)).not().assertUndefined();
      mocker.ignoreMock(appModel, appModel.getAppInfoByBundleNameAndAbility);
      mocker.ignoreMock(commonBundleManager, commonBundleManager.getAbilityInfoByAbilityName);
      mocker.ignoreMock(resourceManager, resourceManager.isSCBInnerModule);
      mocker.ignoreMock(recentMissionsModel, recentMissionsModel.getHapAbilityInfoAsync);
      mocker.ignoreMock(launcherAbilityManager, launcherAbilityManager.getAppLabelId);
    })

    it('getRecentAppInfo_test_14_copy13', TestType.USER | Size.SMALLTEST | Level.LEVEL0, async (): Promise<void> => {
      let appInfoFromCache: AppItemInfo | undefined = new AppItemInfo();
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(appModel, appModel.getAppInfoByBundleNameAndAbility);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(appInfoFromCache);
      let mockFunc2: Function = mocker.mockFunc(commonBundleManager, commonBundleManager.getAbilityInfoByAbilityName);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunc3: Function = mocker.mockFunc(resourceManager, resourceManager.isSCBInnerModule);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);
      let mockFunc4: Function = mocker.mockFunc(recentMissionsModel, recentMissionsModel.getHapAbilityInfoAsync);
      when(mockFunc4)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunc5: Function = mocker.mockFunc(launcherAbilityManager, launcherAbilityManager.getAppLabelId);
      when(mockFunc5)(ArgumentMatchers.any).afterReturn(1);
      expect(RecentTitleViewModel.getRecentAppInfo(sceneInfo)).not().assertUndefined();
      mocker.ignoreMock(appModel, appModel.getAppInfoByBundleNameAndAbility);
      mocker.ignoreMock(commonBundleManager, commonBundleManager.getAbilityInfoByAbilityName);
      mocker.ignoreMock(resourceManager, resourceManager.isSCBInnerModule);
      mocker.ignoreMock(recentMissionsModel, recentMissionsModel.getHapAbilityInfoAsync);
      mocker.ignoreMock(launcherAbilityManager, launcherAbilityManager.getAppLabelId);
    })

    it('getRecentAppInfo_test_14_copy14', TestType.USER | Size.SMALLTEST | Level.LEVEL0, async (): Promise<void> => {
      let appInfoFromCache: AppItemInfo | undefined = new AppItemInfo();
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(appModel, appModel.getAppInfoByBundleNameAndAbility);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(appInfoFromCache);
      let mockFunc2: Function = mocker.mockFunc(commonBundleManager, commonBundleManager.getAbilityInfoByAbilityName);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunc3: Function = mocker.mockFunc(resourceManager, resourceManager.isSCBInnerModule);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);
      let mockFunc4: Function = mocker.mockFunc(recentMissionsModel, recentMissionsModel.getHapAbilityInfoAsync);
      when(mockFunc4)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunc5: Function = mocker.mockFunc(launcherAbilityManager, launcherAbilityManager.getAppLabelId);
      when(mockFunc5)(ArgumentMatchers.any).afterReturn(1);
      expect(RecentTitleViewModel.getRecentAppInfo(sceneInfo)).not().assertUndefined();
      mocker.ignoreMock(appModel, appModel.getAppInfoByBundleNameAndAbility);
      mocker.ignoreMock(commonBundleManager, commonBundleManager.getAbilityInfoByAbilityName);
      mocker.ignoreMock(resourceManager, resourceManager.isSCBInnerModule);
      mocker.ignoreMock(recentMissionsModel, recentMissionsModel.getHapAbilityInfoAsync);
      mocker.ignoreMock(launcherAbilityManager, launcherAbilityManager.getAppLabelId);
    })

    it('getRecentAppInfo_test_14_copy15', TestType.USER | Size.SMALLTEST | Level.LEVEL0, async (): Promise<void> => {
      let appInfoFromCache: AppItemInfo | undefined = new AppItemInfo();
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(appModel, appModel.getAppInfoByBundleNameAndAbility);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(appInfoFromCache);
      let mockFunc2: Function = mocker.mockFunc(commonBundleManager, commonBundleManager.getAbilityInfoByAbilityName);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunc3: Function = mocker.mockFunc(resourceManager, resourceManager.isSCBInnerModule);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);
      let mockFunc4: Function = mocker.mockFunc(recentMissionsModel, recentMissionsModel.getHapAbilityInfoAsync);
      when(mockFunc4)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunc5: Function = mocker.mockFunc(launcherAbilityManager, launcherAbilityManager.getAppLabelId);
      when(mockFunc5)(ArgumentMatchers.any).afterReturn(1);
      expect(RecentTitleViewModel.getRecentAppInfo(sceneInfo)).not().assertUndefined();
      mocker.ignoreMock(appModel, appModel.getAppInfoByBundleNameAndAbility);
      mocker.ignoreMock(commonBundleManager, commonBundleManager.getAbilityInfoByAbilityName);
      mocker.ignoreMock(resourceManager, resourceManager.isSCBInnerModule);
      mocker.ignoreMock(recentMissionsModel, recentMissionsModel.getHapAbilityInfoAsync);
      mocker.ignoreMock(launcherAbilityManager, launcherAbilityManager.getAppLabelId);
    })

    it('getRecentAppInfo_test_14_copy16', TestType.USER | Size.SMALLTEST | Level.LEVEL0, async (): Promise<void> => {
      let appInfoFromCache: AppItemInfo | undefined = new AppItemInfo();
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(appModel, appModel.getAppInfoByBundleNameAndAbility);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(appInfoFromCache);
      let mockFunc2: Function = mocker.mockFunc(commonBundleManager, commonBundleManager.getAbilityInfoByAbilityName);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunc3: Function = mocker.mockFunc(resourceManager, resourceManager.isSCBInnerModule);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);
      let mockFunc4: Function = mocker.mockFunc(recentMissionsModel, recentMissionsModel.getHapAbilityInfoAsync);
      when(mockFunc4)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunc5: Function = mocker.mockFunc(launcherAbilityManager, launcherAbilityManager.getAppLabelId);
      when(mockFunc5)(ArgumentMatchers.any).afterReturn(1);
      expect(RecentTitleViewModel.getRecentAppInfo(sceneInfo)).not().assertUndefined();
      mocker.ignoreMock(appModel, appModel.getAppInfoByBundleNameAndAbility);
      mocker.ignoreMock(commonBundleManager, commonBundleManager.getAbilityInfoByAbilityName);
      mocker.ignoreMock(resourceManager, resourceManager.isSCBInnerModule);
      mocker.ignoreMock(recentMissionsModel, recentMissionsModel.getHapAbilityInfoAsync);
      mocker.ignoreMock(launcherAbilityManager, launcherAbilityManager.getAppLabelId);
    })

    it('getRecentAppInfo_test_14_copy17', TestType.USER | Size.SMALLTEST | Level.LEVEL0, async (): Promise<void> => {
      let appInfoFromCache: AppItemInfo | undefined = new AppItemInfo();
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(appModel, appModel.getAppInfoByBundleNameAndAbility);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(appInfoFromCache);
      let mockFunc2: Function = mocker.mockFunc(commonBundleManager, commonBundleManager.getAbilityInfoByAbilityName);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunc3: Function = mocker.mockFunc(resourceManager, resourceManager.isSCBInnerModule);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);
      let mockFunc4: Function = mocker.mockFunc(recentMissionsModel, recentMissionsModel.getHapAbilityInfoAsync);
      when(mockFunc4)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunc5: Function = mocker.mockFunc(launcherAbilityManager, launcherAbilityManager.getAppLabelId);
      when(mockFunc5)(ArgumentMatchers.any).afterReturn(1);
      expect(RecentTitleViewModel.getRecentAppInfo(sceneInfo)).not().assertUndefined();
      mocker.ignoreMock(appModel, appModel.getAppInfoByBundleNameAndAbility);
      mocker.ignoreMock(commonBundleManager, commonBundleManager.getAbilityInfoByAbilityName);
      mocker.ignoreMock(resourceManager, resourceManager.isSCBInnerModule);
      mocker.ignoreMock(recentMissionsModel, recentMissionsModel.getHapAbilityInfoAsync);
      mocker.ignoreMock(launcherAbilityManager, launcherAbilityManager.getAppLabelId);
    })

    it('getRecentAppInfo_test_14_copy18', TestType.USER | Size.SMALLTEST | Level.LEVEL0, async (): Promise<void> => {
      let appInfoFromCache: AppItemInfo | undefined = new AppItemInfo();
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(appModel, appModel.getAppInfoByBundleNameAndAbility);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(appInfoFromCache);
      let mockFunc2: Function = mocker.mockFunc(commonBundleManager, commonBundleManager.getAbilityInfoByAbilityName);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunc3: Function = mocker.mockFunc(resourceManager, resourceManager.isSCBInnerModule);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);
      let mockFunc4: Function = mocker.mockFunc(recentMissionsModel, recentMissionsModel.getHapAbilityInfoAsync);
      when(mockFunc4)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunc5: Function = mocker.mockFunc(launcherAbilityManager, launcherAbilityManager.getAppLabelId);
      when(mockFunc5)(ArgumentMatchers.any).afterReturn(1);
      expect(RecentTitleViewModel.getRecentAppInfo(sceneInfo)).not().assertUndefined();
      mocker.ignoreMock(appModel, appModel.getAppInfoByBundleNameAndAbility);
      mocker.ignoreMock(commonBundleManager, commonBundleManager.getAbilityInfoByAbilityName);
      mocker.ignoreMock(resourceManager, resourceManager.isSCBInnerModule);
      mocker.ignoreMock(recentMissionsModel, recentMissionsModel.getHapAbilityInfoAsync);
      mocker.ignoreMock(launcherAbilityManager, launcherAbilityManager.getAppLabelId);
    })

    it('getRecentAppInfo_test_14_copy19', TestType.USER | Size.SMALLTEST | Level.LEVEL0, async (): Promise<void> => {
      let appInfoFromCache: AppItemInfo | undefined = new AppItemInfo();
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(appModel, appModel.getAppInfoByBundleNameAndAbility);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(appInfoFromCache);
      let mockFunc2: Function = mocker.mockFunc(commonBundleManager, commonBundleManager.getAbilityInfoByAbilityName);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunc3: Function = mocker.mockFunc(resourceManager, resourceManager.isSCBInnerModule);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);
      let mockFunc4: Function = mocker.mockFunc(recentMissionsModel, recentMissionsModel.getHapAbilityInfoAsync);
      when(mockFunc4)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunc5: Function = mocker.mockFunc(launcherAbilityManager, launcherAbilityManager.getAppLabelId);
      when(mockFunc5)(ArgumentMatchers.any).afterReturn(1);
      expect(RecentTitleViewModel.getRecentAppInfo(sceneInfo)).not().assertUndefined();
      mocker.ignoreMock(appModel, appModel.getAppInfoByBundleNameAndAbility);
      mocker.ignoreMock(commonBundleManager, commonBundleManager.getAbilityInfoByAbilityName);
      mocker.ignoreMock(resourceManager, resourceManager.isSCBInnerModule);
      mocker.ignoreMock(recentMissionsModel, recentMissionsModel.getHapAbilityInfoAsync);
      mocker.ignoreMock(launcherAbilityManager, launcherAbilityManager.getAppLabelId);
    })

    it('getRecentAppInfo_test_14_copy20', TestType.USER | Size.SMALLTEST | Level.LEVEL0, async (): Promise<void> => {
      let appInfoFromCache: AppItemInfo | undefined = new AppItemInfo();
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(appModel, appModel.getAppInfoByBundleNameAndAbility);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(appInfoFromCache);
      let mockFunc2: Function = mocker.mockFunc(commonBundleManager, commonBundleManager.getAbilityInfoByAbilityName);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunc3: Function = mocker.mockFunc(resourceManager, resourceManager.isSCBInnerModule);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);
      let mockFunc4: Function = mocker.mockFunc(recentMissionsModel, recentMissionsModel.getHapAbilityInfoAsync);
      when(mockFunc4)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunc5: Function = mocker.mockFunc(launcherAbilityManager, launcherAbilityManager.getAppLabelId);
      when(mockFunc5)(ArgumentMatchers.any).afterReturn(1);
      expect(RecentTitleViewModel.getRecentAppInfo(sceneInfo)).not().assertUndefined();
      mocker.ignoreMock(appModel, appModel.getAppInfoByBundleNameAndAbility);
      mocker.ignoreMock(commonBundleManager, commonBundleManager.getAbilityInfoByAbilityName);
      mocker.ignoreMock(resourceManager, resourceManager.isSCBInnerModule);
      mocker.ignoreMock(recentMissionsModel, recentMissionsModel.getHapAbilityInfoAsync);
      mocker.ignoreMock(launcherAbilityManager, launcherAbilityManager.getAppLabelId);
    })

    it('getRecentAppInfo_test_14_copy21', TestType.USER | Size.SMALLTEST | Level.LEVEL0, async (): Promise<void> => {
      let appInfoFromCache: AppItemInfo | undefined = new AppItemInfo();
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(appModel, appModel.getAppInfoByBundleNameAndAbility);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(appInfoFromCache);
      let mockFunc2: Function = mocker.mockFunc(commonBundleManager, commonBundleManager.getAbilityInfoByAbilityName);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunc3: Function = mocker.mockFunc(resourceManager, resourceManager.isSCBInnerModule);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);
      let mockFunc4: Function = mocker.mockFunc(recentMissionsModel, recentMissionsModel.getHapAbilityInfoAsync);
      when(mockFunc4)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunc5: Function = mocker.mockFunc(launcherAbilityManager, launcherAbilityManager.getAppLabelId);
      when(mockFunc5)(ArgumentMatchers.any).afterReturn(1);
      expect(RecentTitleViewModel.getRecentAppInfo(sceneInfo)).not().assertUndefined();
      mocker.ignoreMock(appModel, appModel.getAppInfoByBundleNameAndAbility);
      mocker.ignoreMock(commonBundleManager, commonBundleManager.getAbilityInfoByAbilityName);
      mocker.ignoreMock(resourceManager, resourceManager.isSCBInnerModule);
      mocker.ignoreMock(recentMissionsModel, recentMissionsModel.getHapAbilityInfoAsync);
      mocker.ignoreMock(launcherAbilityManager, launcherAbilityManager.getAppLabelId);
    })

    it('getRecentAppInfo_test_14_copy22', TestType.USER | Size.SMALLTEST | Level.LEVEL0, async (): Promise<void> => {
      let appInfoFromCache: AppItemInfo | undefined = new AppItemInfo();
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(appModel, appModel.getAppInfoByBundleNameAndAbility);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(appInfoFromCache);
      let mockFunc2: Function = mocker.mockFunc(commonBundleManager, commonBundleManager.getAbilityInfoByAbilityName);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunc3: Function = mocker.mockFunc(resourceManager, resourceManager.isSCBInnerModule);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);
      let mockFunc4: Function = mocker.mockFunc(recentMissionsModel, recentMissionsModel.getHapAbilityInfoAsync);
      when(mockFunc4)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunc5: Function = mocker.mockFunc(launcherAbilityManager, launcherAbilityManager.getAppLabelId);
      when(mockFunc5)(ArgumentMatchers.any).afterReturn(1);
      expect(RecentTitleViewModel.getRecentAppInfo(sceneInfo)).not().assertUndefined();
      mocker.ignoreMock(appModel, appModel.getAppInfoByBundleNameAndAbility);
      mocker.ignoreMock(commonBundleManager, commonBundleManager.getAbilityInfoByAbilityName);
      mocker.ignoreMock(resourceManager, resourceManager.isSCBInnerModule);
      mocker.ignoreMock(recentMissionsModel, recentMissionsModel.getHapAbilityInfoAsync);
      mocker.ignoreMock(launcherAbilityManager, launcherAbilityManager.getAppLabelId);
    })

    it('getRecentAppInfo_test_14_copy23', TestType.USER | Size.SMALLTEST | Level.LEVEL0, async (): Promise<void> => {
      let appInfoFromCache: AppItemInfo | undefined = new AppItemInfo();
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(appModel, appModel.getAppInfoByBundleNameAndAbility);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(appInfoFromCache);
      let mockFunc2: Function = mocker.mockFunc(commonBundleManager, commonBundleManager.getAbilityInfoByAbilityName);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunc3: Function = mocker.mockFunc(resourceManager, resourceManager.isSCBInnerModule);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);
      let mockFunc4: Function = mocker.mockFunc(recentMissionsModel, recentMissionsModel.getHapAbilityInfoAsync);
      when(mockFunc4)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunc5: Function = mocker.mockFunc(launcherAbilityManager, launcherAbilityManager.getAppLabelId);
      when(mockFunc5)(ArgumentMatchers.any).afterReturn(1);
      expect(RecentTitleViewModel.getRecentAppInfo(sceneInfo)).not().assertUndefined();
      mocker.ignoreMock(appModel, appModel.getAppInfoByBundleNameAndAbility);
      mocker.ignoreMock(commonBundleManager, commonBundleManager.getAbilityInfoByAbilityName);
      mocker.ignoreMock(resourceManager, resourceManager.isSCBInnerModule);
      mocker.ignoreMock(recentMissionsModel, recentMissionsModel.getHapAbilityInfoAsync);
      mocker.ignoreMock(launcherAbilityManager, launcherAbilityManager.getAppLabelId);
    })

    it('init_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      recentTitleViewModel.init();
      expect(recentTitleViewModel.maxWidth).assertEqual(0);
    })

    it('init_getIconId_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      expect(RecentTitleViewModel.getIconId('test')).not().assertUndefined();
    })

    it('init_exit_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      RecentTitleViewModel.exit();
      expect(recentTitleViewModel.maxWidth).not().assertUndefined();
    })

    it('initRecentDataList_test_001', 0, (): void => {
      recentRuntimeInstance.notRemovingSessionList = totalContainerSessionList;
      RecentTitleViewModel.initRecentDataList(property)
      expect(RecentTitleViewModel).not().assertUndefined();
    })

    it('initRecentData_test_001', 0, (): void => {
      recentTitleViewModel.initRecentData(sceneContainerSession);
      expect(RecentTitleViewModel).not().assertUndefined();
    })

    it('initRecentData_test_002', 0, (): void => {
      RecentTitleViewModel.exit();
      recentTitleViewModel.initRecentData(sceneContainerSession);
      expect(RecentTitleViewModel).not().assertUndefined();
    })

    it('initAppInfo_test_001', 0, (): void => {
      let appInfo: AppItemInfo = new AppItemInfo();
      appInfo.appIconId = 0;
      appInfo.appLabelId = 0;
      (RecentTitleViewModel as object)['initAppInfo'](scbSceneContainer, property);
      expect(RecentTitleViewModel).not().assertUndefined();
    })

    it('updateRecentData_test_001', 0, (): void => {
      let appInfo: AppItemInfo = new AppItemInfo();
      appInfo.appIconId = 0;
      appInfo.appLabelId = 0;
      (RecentTitleViewModel as object)['initAppInfo'](scbSceneContainer, property);
      expect(RecentTitleViewModel).not().assertUndefined();
    })

    it('initLockIconStatus_test_001', 0, () => {
      (RecentTitleViewModel as object)['initLockIconStatus'](scbSceneContainer);
      expect(RecentTitleViewModel).not().assertUndefined();
    })

    it('initLockIconStatus_test_002', 0, () => {
      scbSceneContainer.secondarySession = primarySession;
      if (scbSceneContainer.primarySession?.sceneInfo) {
        scbSceneContainer.primarySession.sceneInfo.isLockedInRecent = false;
      }
      (RecentTitleViewModel as object)['initLockIconStatus'](scbSceneContainer);
      expect(RecentTitleViewModel).not().assertUndefined();
    })

    it('initLockIconStatus_test_003', 0, () => {
      scbSceneContainer.secondarySession = primarySession;
      if (scbSceneContainer.primarySession?.sceneInfo) {
        scbSceneContainer.primarySession.sceneInfo.isLockedInRecent = true;
      }
      (RecentTitleViewModel as object)['initLockIconStatus'](scbSceneContainer);
      expect(RecentTitleViewModel).not().assertUndefined();
    })

    it('initSubIconImageAndIconId_test_001', 0, (): void => {
      (recentTitleViewModel as object)['initSubIconImageAndIconId'](primarySession, primarySession);
      expect(RecentTitleViewModel).not().assertUndefined();
    })

    it('updateIconCallback_test_001', 0, (): void => {
      (recentTitleViewModel as object)['updateIconCallback'](icon, false);
      expect(RecentTitleViewModel).not().assertUndefined();
    })

    it('updateIconCallback_test_002', 0, (): void => {
      (recentTitleViewModel as object)['updateIconCallback'](icon, true);
      expect(RecentTitleViewModel).not().assertUndefined();
    })

    it('updateNameCallback_test_001', 0, (): void => {
      (recentTitleViewModel as object)['updateNameCallback']('test', false);
      expect(RecentTitleViewModel).not().assertUndefined();
    })

    it('updateNameCallback_test_002', 0, (): void => {
      (recentTitleViewModel as object)['updateNameCallback']('test', true);
      expect(RecentTitleViewModel).not().assertUndefined();
    })

    sceneInfo.label = 'test';
    primarySession.sceneInfo = sceneInfo;
    scbSceneContainer.dividerParam = new SCBDividerParam();
    it('updatePrimaryIconAndName_test_001', 0, (): void => {
      scbSceneContainer.dividerParam.splitOrderIsNotReverse = true;
      scbSceneContainer.primarySession = null;
      (recentTitleViewModel as object)['updatePrimaryIconAndName'](scbSceneContainer);
      expect(RecentTitleViewModel).not().assertUndefined();
    })

    it('updatePrimaryIconAndName_test_002', 0, (): void => {
      scbSceneContainer.dividerParam.splitOrderIsNotReverse = true;
      scbSceneContainer.primarySession = primarySession;
      (recentTitleViewModel as object)['updatePrimaryIconAndName'](scbSceneContainer);
      expect(RecentTitleViewModel).not().assertUndefined();
    })

    it('updateSecondaryIconAndName_test_001', 0, (): void => {
      scbSceneContainer.dividerParam.splitOrderIsNotReverse = true;
      scbSceneContainer.primarySession = null;
      (recentTitleViewModel as object)['updateSecondaryIconAndName'](scbSceneContainer);
      expect(RecentTitleViewModel).not().assertUndefined();
    })

    it('updateSecondaryIconAndName_test_002', 0, (): void => {
      scbSceneContainer.dividerParam.splitOrderIsNotReverse = true;
      scbSceneContainer.primarySession = primarySession;
      (recentTitleViewModel as object)['updateSecondaryIconAndName'](scbSceneContainer);
      expect(RecentTitleViewModel).not().assertUndefined();
    })

    it('getSession_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, async () => {
      expect(await RecentTitleViewModel.getSession(null)).assertNull();
    })

    it('getSession_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      expect(RecentTitleViewModel.getSession(session)).not().assertUndefined();
    })

    it('getSession_03', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(RecentTitleViewModel, RecentTitleViewModel.getRecentAppInfo);
      when(mockFunc1)(ArgumentMatchers.any).afterThrow('err');;
      expect(RecentTitleViewModel.getSession(session)).not().assertUndefined();
    })

    it('getTitlePosition_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      sceneContainerSession.isFloat = true;
      expect(RecentTitleViewModel.getTitlePosition(sceneContainerSession, property, scale, pos)).not().assertUndefined();
    })

    it('getTitlePosition_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      sceneContainerSession.isFloat = false;
      expect(RecentTitleViewModel.getTitlePosition(sceneContainerSession, property, scale, pos)).not().assertUndefined();
    })

    it('getTitleId_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      expect(RecentTitleViewModel.getTitleId('titleViewTag', null, null)).assertInstanceOf('String');
    })

    it('getTitleId_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      expect(RecentTitleViewModel.getTitleId('titleViewTag', sceneAppInfo, null)).not().assertUndefined();
    })

    it('getTitleId_03', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      expect(RecentTitleViewModel.getTitleId('titleViewTag', sceneAppInfo, sceneAppInfo)).not().assertUndefined();
    })

    it('updateIconAndName_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      RecentTitleViewModel.updateIconAndName(sceneAppInfo, session,
        (image: string | PixelMap | Resource): void => { image; },
        (name: string): void => { name });
    })

    it('updateIconAndName_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      RecentTitleViewModel.updateIconAndName(null, session,
        (image: string | PixelMap | Resource): void => { image; },
        (name: string): void => { name });
    })

    it('updateIconAndName_03', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      sceneAppInfo.bundleName = 'testName';
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(resourceManager, resourceManager.isSCBInnerModule);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

      RecentTitleViewModel.updateIconAndName(sceneAppInfo, session,
        (image: string | PixelMap | Resource): void => { image; },
        (name: string): void => { name });
      mocker.ignoreMock(resourceManager, resourceManager.isSCBInnerModule);
    })

    it('updateIconAndName_04', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      sceneAppInfo.bundleName = 'testName';
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(resourceManager, resourceManager.isSCBInnerModule);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

      RecentTitleViewModel.updateIconAndName(sceneAppInfo, session,
        (image: string | PixelMap | Resource): void => { image; },
        (name: string): void => { name });
      mocker.ignoreMock(resourceManager, resourceManager.isSCBInnerModule);
    })

    it('updateIconAndName_05', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      sceneAppInfo.bundleName = 'testName';
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(resourceManager, resourceManager.isSCBInnerModule);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      sceneAppInfo.appIndex = 10;
      sceneAppInfo.bundleName = 'name';
      let mockFunc1: Function = mocker.mockFunc(iconResourceManager, iconResourceManager.getCombIcon);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(icon);
      RecentTitleViewModel.updateIconAndName(sceneAppInfo, session,
        (image: string | PixelMap | Resource): void => { image; },
        (name: string): void => { name });
      mocker.ignoreMock(resourceManager, resourceManager.isSCBInnerModule);
      mocker.ignoreMock(iconResourceManager, iconResourceManager.getCombIcon);
    })

    it('updateIconAndName_06', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      sceneAppInfo.bundleName = VassistantConstants.VASSISTANT_BUNDLE_NAME;
      sceneAppInfo.moduleName = VassistantConstants.DEFAULT_MODULE_NAME;
      sceneAppInfo.abilityName = VassistantConstants.VASSISTANT_ABILITY_NAME;
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(resourceManager, resourceManager.isSCBInnerModule);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      sceneAppInfo.appIndex = 10;
      sceneAppInfo.bundleName = 'name';
      let mockFunc1: Function = mocker.mockFunc(iconResourceManager, iconResourceManager.getCombIcon);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(icon);
      RecentTitleViewModel.updateIconAndName(sceneAppInfo, session,
        (image: string | PixelMap | Resource): void => { image; },
        (name: string): void => { name });
      mocker.ignoreMock(resourceManager, resourceManager.isSCBInnerModule);
      mocker.ignoreMock(iconResourceManager, iconResourceManager.getCombIcon);
    })

    it('updateIconAndName_06', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      sceneAppInfo.bundleName = 'test';
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(resourceManager, resourceManager.isSCBInnerModule);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      sceneAppInfo.appIndex = 10;
      sceneAppInfo.bundleName = 'name';
      let mockFunc1: Function = mocker.mockFunc(iconResourceManager, iconResourceManager.getCachedIconNameSync);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn('test');
      RecentTitleViewModel.updateIconAndName(sceneAppInfo, session,
        (image: string | PixelMap | Resource): void => { image; },
        (name: string): void => { name });
      mocker.ignoreMock(resourceManager, resourceManager.isSCBInnerModule);
      mocker.ignoreMock(iconResourceManager, iconResourceManager.getCombIcon);
    })

    it('playTitleDisAppearAnimation_test_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      RecentTitleViewModel.playTitleDisAppearAnimation(sceneContainerSession);
      expect(RecentTitleViewModel).not().assertUndefined();
    })

    let iconCallback: (image: string | PixelMap | Resource) => void = (): void => {
    }

    it('updateIcon_test_001', 0, async (done: Function): Promise<void> => {
      let appInfo: AppItemInfo = new AppItemInfo();
      appInfo.appIconId = 0;
      appInfo.appIndex = 10;
      appInfo.appLabelId = 1;
      appInfo.bundleName = 'test';
      let mock = new MockKit();
      let mockFun = mock.mockFunc(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
      let mockFun1 = mock.mockFunc(ResourceManager.getInstance(), ResourceManager.getInstance().isSCBInnerModule);
      let mockFun2 = mock.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFun)(ArgumentMatchers.any).afterReturn(false);
      when(mockFun1)(ArgumentMatchers.any).afterReturn(false);
      when(mockFun2)(ArgumentMatchers.any).afterReturn(true);
      await (RecentTitleViewModel as object)['updateIcon'](appInfo, iconCallback);
      expect(RecentTitleViewModel).not().assertUndefined();
      mock.ignoreMock(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
      mock.ignoreMock(ResourceManager.getInstance(), ResourceManager.getInstance().isSCBInnerModule);
      mock.ignoreMock(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      done();
    })

    it('updateIcon_test_002', 0, async (done: Function): Promise<void> => {
      let appInfo: AppItemInfo = new AppItemInfo();
      appInfo.appIconId = 0;
      appInfo.appIndex = 10;
      appInfo.appLabelId = 1;
      appInfo.bundleName = 'test';
      let mock = new MockKit();
      let mockFun = mock.mockFunc(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
      let mockFun1 = mock.mockFunc(ResourceManager.getInstance(), ResourceManager.getInstance().isSCBInnerModule);
      let mockFun2 = mock.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFun)(ArgumentMatchers.any).afterReturn(false);
      when(mockFun1)(ArgumentMatchers.any).afterReturn(false);
      when(mockFun2)(ArgumentMatchers.any).afterReturn(false);
      await (RecentTitleViewModel as object)['updateIcon'](appInfo, iconCallback);
      expect(RecentTitleViewModel).not().assertUndefined();
      mock.ignoreMock(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
      mock.ignoreMock(ResourceManager.getInstance(), ResourceManager.getInstance().isSCBInnerModule);
      mock.ignoreMock(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      done();
    })

    it('updateIconForSCBSceneInfo_test_001', 0, (): void => {
      RecentTitleViewModel.updateIconForSCBSceneInfo(null, iconCallback);
      expect(RecentTitleViewModel).not().assertUndefined();
    })

    it('updateIconForSCBSceneInfo_test_002', 0, (): void => {
      sceneInfo.appIndex = 10;
      sceneInfo.bundleName = 'name';
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(resourceManager, resourceManager.isSCBInnerModule);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      let mockFunc1: Function = mocker.mockFunc(iconResourceManager, iconResourceManager.getCombIcon);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(icon);
      RecentTitleViewModel.updateIconForSCBSceneInfo(sceneInfo, iconCallback);
      expect(RecentTitleViewModel).not().assertUndefined();
      mocker.ignoreMock(resourceManager, resourceManager.isSCBInnerModule);
      mocker.ignoreMock(iconResourceManager, iconResourceManager.getCombIcon);
    })

    it('playTitleDisAppearAnimation_test_001', 0, (): void => {
      (RecentTitleViewModel as object)['playTitleDisAppearAnimation']();
      expect(RecentTitleViewModel).not().assertUndefined();
      RecentTitleViewModel.playTitleDisAppearAnimation(sceneContainerSession);
      expect(RecentTitleViewModel).not().assertUndefined();
      (RecentTitleViewModel as object)['isNewStyle'] = true;
      RecentTitleViewModel.playTitleDisAppearAnimation(sceneContainerSession);
      expect(RecentTitleViewModel).not().assertUndefined();
      (RecentTitleViewModel as object)['isNewStyle'] = false;
      RecentTitleViewModel.playTitleDisAppearAnimation(sceneContainerSession);
      expect(RecentTitleViewModel).not().assertUndefined();
    })

    it('getAppInfoFromBms_test_001', 0, (): void => {
      let appInfo: AppItemInfo = new AppItemInfo();
      appInfo.appIconId = 0;
      appInfo.appLabelId = 0;
      (RecentTitleViewModel as object)['getAppInfoFromBms'](appItemInfo, appInfo);
      expect(RecentTitleViewModel).not().assertUndefined();
    })

    it('getAppInfoFromHapAbility_test_001', 0, (): void => {
      let appInfo: AppItemInfo = new AppItemInfo();
      appInfo.appIconId = 0;
      appInfo.appLabelId = 0;
      (RecentTitleViewModel as object)['getAppInfoFromHapAbility'](appItemInfo, appInfo);
      expect(RecentTitleViewModel).not().assertUndefined();
    })

  })
}