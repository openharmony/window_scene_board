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
  ArgumentMatchers,
  beforeAll,
  beforeEach,
  describe,
  expect,
  it,
  MockKit,
  when,
} from '@ohos/hypium';
import { editModeManager, GridLayoutItemInfo } from '@ohos/launchercommon';
import { AiSuggestionDragEventProcessor,
  DragEventParams } from '../../../../../../main/ets/default/event/AiSuggestionDragEventProcessor';
import {
  AiSuggestionItemStateController
} from '../../../../../../main/ets/default/event/AiSuggestionItemStateController';
import { AiSuggestionFormManager } from '../../../../../../main/ets/default/manager/AiSuggestionFormManager';
import { AiSuggestionViewData } from '../../../../../../main/ets/default/viewmodel/AiSuggestionViewData';

export function AiSuggestionDragEventProcessorTest() {
  describe('AiSuggestionDragEventProcessorTest', (): void => {
    beforeAll((): void => {
    });

    beforeEach((): void => {
    });

    afterAll((): void => {
    });

    afterEach((): void => {
    });

    it('constructor', 0, (): void => {
      let form: GridLayoutItemInfo = { cardId: '123' } as GridLayoutItemInfo;
      let controller: AiSuggestionItemStateController = {
        prepareToUninstall: (() => {}),
        setAppNameBackgroundColor: ((color: string) => {}),
      } as AiSuggestionItemStateController;
      let eventProcessor: AiSuggestionDragEventProcessor
        = new AiSuggestionDragEventProcessor({ formItem: form, itemStateController: controller } as DragEventParams);
      eventProcessor.destroy();
    });

    it('onGestureJudgeBegin', 0, (): void => {
      let form: GridLayoutItemInfo = { cardId: '123' } as GridLayoutItemInfo;
      let eventProcessor: AiSuggestionDragEventProcessor
        = new AiSuggestionDragEventProcessor({ formItem: form } as DragEventParams);
      let ret: GestureJudgeResult =
        eventProcessor.onGestureJudgeBegin({ type: 0 } as GestureInfo, {} as BaseGestureEvent);
      expect(ret).assertEqual(GestureJudgeResult.CONTINUE);

      let mocker: MockKit = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(editModeManager, editModeManager.isInEditMode);
      when(mockFunc)().afterReturn(true);
      let mockFunc2: Function =
        mocker.mockFunc(editModeManager, editModeManager.isDraggable);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);
      ret = eventProcessor.onGestureJudgeBegin({ type: 6 } as GestureInfo, {} as BaseGestureEvent);
      expect(ret).assertEqual(GestureJudgeResult.REJECT);

      mocker.clear(editModeManager);
      mocker.clearAll();
    });

    it('DragEventProcessorTest_setFormSize', 0, (): void => {
      let form: GridLayoutItemInfo = { cardId: '123' } as GridLayoutItemInfo;
      let eventProcessor: AiSuggestionDragEventProcessor
        =
        new AiSuggestionDragEventProcessor({ formItem: form, formItemWidth: 1, formItemHeight: 1 } as DragEventParams);
      eventProcessor.setFormSize(0, 1);
      expect((eventProcessor as object)['formItemWidth']).assertEqual(1);

      eventProcessor.setFormSize(1, 0);
      expect((eventProcessor as object)['formItemWidth']).assertEqual(1);

      eventProcessor.setFormSize(-1, 1);
      expect((eventProcessor as object)['formItemWidth']).assertEqual(1);

      eventProcessor.setFormSize(1, -1);
      expect((eventProcessor as object)['formItemWidth']).assertEqual(1);

      eventProcessor.setFormSize(2, 2);
      expect((eventProcessor as object)['formItemWidth']).assertEqual(2);
      eventProcessor.destroy();
    });

    it('DragEventProcessorTest_onFormItemDraggedRemoved', 0, (): void => {
      let form: GridLayoutItemInfo = { cardId: '123' } as GridLayoutItemInfo;
      let eventProcessor: AiSuggestionDragEventProcessor
        = new AiSuggestionDragEventProcessor({ formItem: form, formItemWidth: 1 } as DragEventParams);
      let instance: AiSuggestionFormManager = AiSuggestionFormManager.getInstance();
      let called: boolean = false;
      let action: () => void = (): void => {
        called = true;
      };
      const mocker: MockKit = new MockKit();
      let func: Function = mocker.mockFunc(instance, instance.deleteCardInfo);
      when(func)('123').afterAction(action);
      (eventProcessor as object)['onFormItemDraggedRemoved']('123', '1234');
      expect(called).assertFalse();
      mocker.clear(instance);
      mocker.clearAll();
    });

    it('DragEventProcessorTest_dragEnd_01', 0, (): void => {
      let form: GridLayoutItemInfo = { cardId: '123' } as GridLayoutItemInfo;
      let controller: AiSuggestionItemStateController = {
        prepareToUninstall: (() => {
        }),
        setAppNameBackgroundColor: ((color: string) => {
        }),
      } as AiSuggestionItemStateController;
      let viewData: AiSuggestionViewData = new AiSuggestionViewData();
      let eventProcessor: AiSuggestionDragEventProcessor
        = new AiSuggestionDragEventProcessor({
        formItem: form,
        viewData: viewData,
        itemStateController: controller,
      } as DragEventParams);
      eventProcessor.dragEnd();
      expect((eventProcessor as object)['viewData']['isFormShow']).assertTrue();
    });

    it('DragEventProcessorTest_dragEnd_02', 0, (): void => {
      let form: GridLayoutItemInfo = { cardId: '123' } as GridLayoutItemInfo;
      let controller: AiSuggestionItemStateController = {
        prepareToUninstall: (() => {
        }),
        setAppNameBackgroundColor: ((color: string) => {
        }),
      } as AiSuggestionItemStateController;
      let viewData: AiSuggestionViewData = new AiSuggestionViewData();
      viewData.isFormShow = false;
      let eventProcessor: AiSuggestionDragEventProcessor
        = new AiSuggestionDragEventProcessor({
        formItem: form,
        viewData: viewData,
        itemStateController: controller,
      } as DragEventParams);
      eventProcessor.dragEnd();
      expect((eventProcessor as object)['viewData']['isFormShow']).assertTrue();
    });

  });
}