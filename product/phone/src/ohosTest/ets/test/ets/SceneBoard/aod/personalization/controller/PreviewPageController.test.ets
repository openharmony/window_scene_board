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

import { describe, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { StyleGroupName } from '@ohos/phonebase/src/main/ets/SceneBoard/aod/personalization/constant/Constant';
import { PreviewPageController } from '@ohos/phonebase/src/main/ets/SceneBoard/aod/personalization/controller/PreviewPageController'
import { PageController } from '@ohos/phonebase/src/main/ets/SceneBoard/aod/personalization/controller/PageController'
import { AodStyleModel } from '@ohos/phonebase/src/main/ets/SceneBoard/aod/personalization/model/AodStyleModel'
import { AodStyleDataManager } from '@ohos/phonebase/src/main/ets/SceneBoard/aod/personalization/manager/AodStyleDataManager'
import {
  AodStyleGroupModel
} from '@ohos/phonebase/src/main/ets/SceneBoard/aod/personalization/model/AodStyleGroupModel';
import {
  AodStylePreviewModel
} from '@ohos/phonebase/src/main/ets/SceneBoard/aod/personalization/model/AodStylePreviewModel';

export function PreviewPageControllerTest() {
  let previewPageController: PreviewPageController = new PreviewPageController();
  describe('PreviewPageControllerTest', () => {

    const AodStyleModelFalse:AodStyleModel= new AodStyleModel();
    const AodStyleModelTrue:AodStyleModel= new AodStyleModel();
    AodStyleModelTrue.isApplied = true;
    AodStyleModelTrue.isSelected = true;
    AodStyleModelTrue.groupName = StyleGroupName.INVALID;

    it('test_initStyleGroup_if', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(AodStyleDataManager.getInstance(), AodStyleDataManager.getInstance().getStyleListConfig);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(undefined);

      const aodPreviewPageController = new PreviewPageController();
      aodPreviewPageController.initStyleGroup();
      expect(aodPreviewPageController !== null).assertEqual(true);
      mocker.clear(AodStyleDataManager.getInstance());
      mocker.clearAll();
    });

    it('test_initPreviewStyle', 0, () => {
      const aodPreviewPageController = new PreviewPageController();
      aodPreviewPageController.initPreviewStyle(AodStyleModelTrue);
      expect(aodPreviewPageController !== null).assertEqual(true);
    });

    it('test_initPreviewStyle_if', 0, () => {
      const aodPreviewPageController = new PreviewPageController();
      aodPreviewPageController.initPreviewStyle(AodStyleModelFalse);
      expect(aodPreviewPageController !== null).assertEqual(true);
    });

    it('test_switchPreviewStyle_if', 0, () => {
      const aodPreviewPageController = new PreviewPageController();
      const aodStyleModel : AodStyleModel = new AodStyleModel();
      aodStyleModel.index = 0;
      aodStyleModel.groupName = StyleGroupName.CLASSIC;
      const aodPageController = new PageController();
      aodPageController.updateSelectedStyle(aodStyleModel);
      aodPreviewPageController.switchPreviewStyle(aodStyleModel);
      expect(aodPreviewPageController !== null).assertEqual(true);
    });

    it('test_switchPreviewStyle', 0, () => {
      const aodPreviewPageController = new PreviewPageController();
      const aodStyleModel : AodStyleModel = new AodStyleModel();
      aodStyleModel.index = 0;
      aodStyleModel.groupName = StyleGroupName.CLASSIC;
      const aodPageController = new PageController();
      aodPageController.updateSelectedStyle(aodStyleModel);
      aodPreviewPageController.switchPreviewStyle(AodStyleModelTrue);
      expect(aodPreviewPageController !== null).assertEqual(true);
    });

    it('PreviewPageController_getMainPageController', 0, () => {
      let result = previewPageController.getMainPageController();
      expect(result === null).assertFalse();
    })

    it('PreviewPageController_getInitialStyleListName', 0, () => {
      let result = previewPageController.getInitialStyleListName();
      let styleGroupName: StyleGroupName = (previewPageController as object)['initialStyleListName'];
      expect(result).assertEqual(styleGroupName);
    })

    it('PreviewPageController_getStyleGroup', 0, () => {
      let result = previewPageController.getStyleGroup();
      let aodStyleGroupModel: AodStyleGroupModel = (previewPageController as object)['styleGroup'];
      expect(result).assertEqual(aodStyleGroupModel);
    })

    it('PreviewPageController_getGroupIndex', 0, () => {
      let result = previewPageController.getGroupIndex();
      let groupIndex: number = (previewPageController as object)['groupIndex'];
      expect(result).assertEqual(groupIndex);
    })

    it('PreviewPageController_getPreviewStyle', 0, () => {
      let result = previewPageController.getPreviewStyle();
      let aodStyleModel: AodStyleModel = (previewPageController as object)['previewStyle']['style'];
      expect(result).assertEqual(aodStyleModel);
    })

    it('PreviewPageController_getPreviewModel', 0, () => {
      let result = previewPageController.getPreviewModel();
      let aodStylePreviewModel: AodStylePreviewModel = (previewPageController as object)['previewStyle'];
      expect(result).assertEqual(aodStylePreviewModel);
    })

    it('PreviewPageController_refreshFullScreenStyleGroup1', 0, () => {
      let aodStyleGroupModel: AodStyleGroupModel = new AodStyleGroupModel();
      aodStyleGroupModel.name = StyleGroupName.FULL_SCREEN;
      (previewPageController as object)['styleGroup'] = aodStyleGroupModel;
      previewPageController.refreshFullScreenStyleGroup(true);
      expect(aodStyleGroupModel).not().assertUndefined();
    })

    it('PreviewPageController_refreshFullScreenStyleGroup2', 0, () => {
      let aodStyleGroupModel: AodStyleGroupModel = new AodStyleGroupModel();
      aodStyleGroupModel.name = StyleGroupName.FULL_SCREEN;
      (previewPageController as object)['styleGroup'] = aodStyleGroupModel;
      previewPageController.refreshFullScreenStyleGroup(false);
      expect(aodStyleGroupModel).not().assertUndefined();
    })

    it('PreviewPageController_releaseRes1', 0, () => {
      let aodStyleGroupModel: AodStyleGroupModel = new AodStyleGroupModel();
      aodStyleGroupModel.name = StyleGroupName.FULL_SCREEN;
      (previewPageController as object)['styleGroup'] = aodStyleGroupModel;
      previewPageController.releaseRes();
      expect(aodStyleGroupModel).not().assertUndefined();
    })

    it('PreviewPageController_releaseRes2', 0, () => {
      let aodStyleGroupModel: AodStyleGroupModel = new AodStyleGroupModel();
      aodStyleGroupModel.name = StyleGroupName.WINDOW;
      (previewPageController as object)['styleGroup'] = aodStyleGroupModel;
      previewPageController.releaseRes();
      expect(aodStyleGroupModel).not().assertUndefined();
    })
  })
}