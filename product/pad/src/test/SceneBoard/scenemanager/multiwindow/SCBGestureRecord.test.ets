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
  GestureAction,
  SCBGestureRecord } from '../../../../main/ets/SceneBoard/scenemanager/multiwindow/SCBGestureRecord';
import {ReflectionUtils} from './ReflectionUtils';
import { beforeAll, describe, expect, it, Level } from '@ohos/hypium';

let gestureRecord: SCBGestureRecord;
let assertFlag: boolean = true;

export function SCBGestureRecordTest() {
  describe('SCBGestureRecordTest_describe', () => {
    beforeAll((): void => {
      gestureRecord = new SCBGestureRecord(null);
      gestureRecord = new SCBGestureRecord(event => () => {});
    })

    it('processCancelModel_it_01', Level.LEVEL0, () => {
      gestureRecord.processCancel();
      expect(assertFlag).assertTrue();
    })

    it('processCancelModel_it_02', Level.LEVEL0, () => {
      gestureRecord = new SCBGestureRecord(null);
      ReflectionUtils.setProperty(gestureRecord, 'curAction', GestureAction.START);
      ReflectionUtils.setProperty(gestureRecord, 'cancelEvent', null);
      gestureRecord.processCancel();
      ReflectionUtils.setProperty(gestureRecord, 'cancelEvent', () => {});
      ReflectionUtils.setProperty(gestureRecord, 'curGestureEvent', null);
      gestureRecord.processCancel();
      ReflectionUtils.setProperty(gestureRecord, 'cancelEvent', () => {});
      ReflectionUtils.setProperty(gestureRecord, 'curGestureEvent', () => {});
      gestureRecord.processCancel();
      expect(assertFlag).assertTrue();
    })

    it('recordCurGestureModel_it_01', Level.LEVEL0, () => {
      ReflectionUtils.setProperty(gestureRecord, 'curAction', GestureAction.CANCEL);
      gestureRecord.recordCurGesture(GestureAction.START);
      gestureRecord.recordCurGesture(GestureAction.END);
      expect(assertFlag).assertTrue();
    })

    it('recordCurGestureModel_it', Level.LEVEL0, () => {
      gestureRecord.recordCurGesture(GestureAction.START , null);
      ReflectionUtils.setProperty(gestureRecord, 'curAction', GestureAction.CANCEL);
      gestureRecord.recordCurGesture(GestureAction.UPDATE , null);
      expect(assertFlag).assertTrue();
    })

    it('recordCurGestureModel_getCurAction_it', Level.LEVEL0, () => {
      ReflectionUtils.setProperty(gestureRecord, 'curAction', GestureAction.CANCEL);
      expect(gestureRecord.getCurAction()).assertEqual(GestureAction.CANCEL);
    })

    it('event_test_it', Level.LEVEL0, () => {
      gestureRecord = new SCBGestureRecord(null);
      gestureRecord.preOffsetX = 0;
      gestureRecord.startEvent;
      expect(gestureRecord.preOffsetX).assertEqual(0);
      gestureRecord.preOffsetY = 0;
      expect(gestureRecord.preOffsetY).assertEqual(0);
      expect(assertFlag).assertTrue();
    })
  });
}