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
import CardLockManager from '@ohos/launchercommon/src/main/ets/manager/CardLockManager';
import {
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  it,
  describe,
  expect,
  MockKit,
  when,
  ArgumentMatchers,
} from '@ohos/hypium';
import { CardItemInfo, ContextMenuListener, layoutLockUtil, MenuInfo, MenuInfoManager } from '@ohos/launchercommon';
import { FormStackItemInfo } from '../../../../../main/ets/common/FormStackItemInfo';
import { FormStackMenuViewModel } from '../../../../../main/ets/viewmodel/FormStackMenuViewModel';
import { FormStackTestUtil } from '../common/FormStackTestUtil';
import { relationalStore } from '@kit.ArkData';

export function FormStackMenuViewModelTest() {
  describe('FormStackMenuViewModelTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('FormStackMenuViewModelTest_getFormMenuInFormStack', 0, () => {
      let parentItem: FormStackItemInfo = new FormStackItemInfo();
      let viewModel: FormStackMenuViewModel = new FormStackMenuViewModel(parentItem);
      let cardInfo: CardItemInfo = FormStackTestUtil.createCardItemInfo('idString');
      let menuInfoList: MenuInfo[] = viewModel.getFormStackMenuInfoList(cardInfo);
      expect(menuInfoList).not().assertNull();
    });

    it('FormStackMenuViewModelTest_getFormStackMenuInfoList', 0, () => {
      let parentItem: FormStackItemInfo = new FormStackItemInfo();
      let viewModel: FormStackMenuViewModel = new FormStackMenuViewModel(parentItem);
      let cardInfo: CardItemInfo = FormStackTestUtil.createCardItemInfo('idString');
      let menuInfoList: Array<MenuInfo> = viewModel.getFormStackMenuInfoList(cardInfo);
      expect(menuInfoList).not().assertNull();
    });

    it('FormStackMenuViewModelTest_editForm', 0, () => {
      let parentItem: FormStackItemInfo = new FormStackItemInfo();
      let viewModel: FormStackMenuViewModel = new FormStackMenuViewModel(parentItem);
      let cardInfo: CardItemInfo = FormStackTestUtil.createCardItemInfo('idString');
      (viewModel as object)['getCardMenuList'](cardInfo, cardInfo, 'menuName', () => {});
      let menuInfoList: MenuInfo[] = (viewModel as object)['getContextMenuList'](cardInfo);
      expect(menuInfoList).not().assertNull();
    });

    let parentItem: FormStackItemInfo = new FormStackItemInfo();
    let viewModel: FormStackMenuViewModel = new FormStackMenuViewModel(parentItem);
    let cardInfo: CardItemInfo = {
      id: 'a',
      container: 1,
      name: 'b',
      typeId: 0,
      cardId: 'c',
      bundleName: 'd',
      abilityName: 'e',
      moduleName: 'f',
      mainModuleName: 'g',
      cardName: 'h',
      cardDimension: 0,
      area: [1, 2, 3],
      description: 'aa',
      formConfigAbility: 'ability://',
      appLabelId: 1,
      appName: 'cc',
      supportDimensions: [1, 2],
      page: 1,
      column: 1,
      row: 1,
      totleDimensionCount: 1,
      isTransparent: false,
      displayNameId: 0,
      dimension: 0,
      dragLayerWidth: 0,
      dragLayerHeight: 0,
      descriptionId: 0,
      showInCenter: false,
      renderingMode: 0,
      fromResultSet: (resultSet: relationalStore.ResultSet): CardItemInfo => {
        return new CardItemInfo();
      }
    } as CardItemInfo;
    let menuInfo: MenuInfo = new MenuInfo();
    let menuInfoList: MenuInfo[] = [menuInfo, menuInfo, menuInfo];
    let listener: ContextMenuListener = {
      onMenuBuild: (containerType: number, responseType?: ResponseType): MenuInfo[] => {
        return menuInfoList;
      }
    }

    it('getContextMenuList_test01', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc =
        mocker.mockFunc(MenuInfoManager.getInstance(), MenuInfoManager.getInstance().getContextMenuListener);
      when(mockFunc)().afterReturn(listener);
      (viewModel as object)['getContextMenuList'](cardInfo);
      expect(viewModel).not().assertUndefined();
      mocker.clear(MenuInfoManager.getInstance());
    });

    it('getContextMenuList_test02', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc =
        mocker.mockFunc(MenuInfoManager.getInstance(), MenuInfoManager.getInstance().getContextMenuListener);
      when(mockFunc)().afterReturnNothing;
      (viewModel as object)['getContextMenuList'](cardInfo);
      expect(viewModel).not().assertUndefined();
      mocker.clear(MenuInfoManager.getInstance());
    });

    it('getCardMenuList_test01', 0, () => {
      (viewModel as object)['getCardMenuList'](cardInfo, cardInfo, 'a', () => {
      });
      expect(viewModel).not().assertUndefined();
    });

    it('getCardMenuList_test02', 0, () => {
      let cardInfo: CardItemInfo = {
        id: 'a',
        container: 1,
        name: 'b',
        typeId: 0,
        cardId: 'c',
        bundleName: 'd',
        abilityName: 'e',
        moduleName: 'f',
        mainModuleName: 'g',
        cardName: 'h',
        cardDimension: 0,
        area: [1, 2, 3],
        description: 'aa',
        formConfigAbility: undefined,
        appLabelId: 1,
        appName: 'cc',
        supportDimensions: [1, 2],
        page: 1,
        column: 1,
        row: 1,
        totleDimensionCount: 1,
        isTransparent: false,
        displayNameId: 0,
        dimension: 0,
        dragLayerWidth: 0,
        dragLayerHeight: 0,
        descriptionId: 0,
        showInCenter: false,
        renderingMode: 0,
        fromResultSet: (resultSet: relationalStore.ResultSet): CardItemInfo => {
          return new CardItemInfo();
        }
      } as CardItemInfo;
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(layoutLockUtil, layoutLockUtil.isLockedPage);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      (viewModel as object)['getCardMenuList'](cardInfo, cardInfo, 'a', () => {
      });
      expect(viewModel).not().assertUndefined();
      mocker.clear((viewModel as object));
      mocker.clear(layoutLockUtil);
    });

    it('getCardMenuList_test03', 0, () => {
      let cardInfo: CardItemInfo = {
        id: 'a',
        container: 1,
        name: 'b',
        typeId: 0,
        cardId: 'c',
        bundleName: 'd',
        abilityName: 'e',
        moduleName: 'f',
        mainModuleName: 'g',
        cardName: 'h',
        cardDimension: 0,
        area: [1, 2, 3],
        description: 'aa',
        formConfigAbility: undefined,
        appLabelId: 1,
        appName: 'cc',
        supportDimensions: [1, 2],
        page: 1,
        column: 1,
        row: 1,
        totleDimensionCount: 1,
        isTransparent: false,
        displayNameId: 0,
        dimension: 0,
        dragLayerWidth: 0,
        dragLayerHeight: 0,
        descriptionId: 0,
        showInCenter: false,
        renderingMode: 0,
        fromResultSet: (resultSet: relationalStore.ResultSet): CardItemInfo => {
          return new CardItemInfo();
        }
      } as CardItemInfo;
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(layoutLockUtil, layoutLockUtil.isLockedPage);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      (viewModel as object)['getCardMenuList'](cardInfo, cardInfo, 'a', () => {
      });
      expect(viewModel).not().assertUndefined();
      mocker.clear((viewModel as object));
      mocker.clear(layoutLockUtil);
    });


    it('getCardMenuList_test04', 0, () => {
      let cardInfo: CardItemInfo = {
        id: 'a',
        container: 1,
        name: 'b',
        typeId: 0,
        cardId: 'c',
        bundleName: 'd',
        abilityName: 'e',
        moduleName: 'f',
        mainModuleName: 'g',
        cardName: 'h',
        cardDimension: 0,
        area: [1, 2, 3],
        description: 'aa',
        formConfigAbility: 'ability://',
        appLabelId: 1,
        appName: 'cc',
        supportDimensions: [1, 2],
        page: 1,
        column: 1,
        row: 1,
        totleDimensionCount: 1,
        isTransparent: false,
        displayNameId: 0,
        dimension: 0,
        dragLayerWidth: 0,
        dragLayerHeight: 0,
        descriptionId: 0,
        showInCenter: false,
        renderingMode: 0,
        fromResultSet: (resultSet: relationalStore.ResultSet): CardItemInfo => {
          return new CardItemInfo();
        }
      } as CardItemInfo;
      let viewModel: FormStackMenuViewModel = new FormStackMenuViewModel(parentItem);
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(CardLockManager, CardLockManager.getInstance);
      when(mockFunc)(ArgumentMatchers.any).afterReturn({
        mainAppHasLock() {
          return true;
        },
        getLockedCardIsReleased() {
          return true;
        }
      });
      expect((viewModel as object)['hasAuthToEditForm'](cardInfo)).assertTrue();
      when(mockFunc)(ArgumentMatchers.any).afterReturn({
        mainAppHasLock() {
          return false;
        },
        getLockedCardIsReleased() {
          return true;
        }
      });
      expect((viewModel as object)['hasAuthToEditForm'](cardInfo)).assertTrue();
    })

    it('getCardMenuList_test05', 0, () => {
      let cardInfo: CardItemInfo = {
        id: 'a',
        container: 1,
        name: 'b',
        typeId: 0,
        cardId: 'c',
        bundleName: 'd',
        abilityName: 'e',
        moduleName: 'f',
        mainModuleName: 'g',
        cardName: 'h',
        cardDimension: 0,
        area: [1, 2, 3],
        description: 'aa',
        formConfigAbility: 'ability://',
        appLabelId: 1,
        appName: 'cc',
        supportDimensions: [1, 2],
        page: 1,
        column: 1,
        row: 1,
        totleDimensionCount: 1,
        isTransparent: false,
        displayNameId: 0,
        dimension: 0,
        dragLayerWidth: 0,
        dragLayerHeight: 0,
        descriptionId: 0,
        showInCenter: false,
        renderingMode: 0,
        fromResultSet: (resultSet: relationalStore.ResultSet): CardItemInfo => {
          return new CardItemInfo();
        }
      } as CardItemInfo;
      let viewModel: FormStackMenuViewModel = new FormStackMenuViewModel(parentItem);
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(CardLockManager, CardLockManager.getInstance);
      when(mockFunc)(ArgumentMatchers.any).afterReturn({
        mainAppHasLock() {
          return true;
        },
        getLockedCardIsReleased() {
          return true;
        }
      });
      expect(viewModel.getFormMenuInFormStack(cardInfo, undefined, 'zhangsan', () => {}) === undefined).assertFalse();
      when(mockFunc)(ArgumentMatchers.any).afterReturn({
        mainAppHasLock() {
          return false;
        },
        getLockedCardIsReleased() {
          return true;
        }
      });
      expect((viewModel as object)['hasAuthToEditForm'](cardInfo)).assertTrue();
    })
  });
}