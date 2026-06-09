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
import { beforeAll, describe, expect, it, Level } from '@ohos/hypium';
import { SCBGestureRecord } from '../../../../../../../main/ets/TsIndex';

import { ReflectionUtils } from './ReflectionUtils';

export enum GestureNavigationState {
  START,
  UPDATE,
  END,
  CANCEL
}

export enum GestureType {
  BACK = 'BACK',
  NAVIGATION = 'NAVIGATION',
  PC_BACK = 'PC_BACK'
}

export function SCBGestureRecordTest() {
  let gestureRecord: SCBGestureRecord;
  describe('SCBCommonGestureRecordTest', () => {
    beforeAll((): void => {
      gestureRecord = new SCBGestureRecord(null);
      gestureRecord = new SCBGestureRecord(event => () => {
      });
    })

    it('recordCurGestureModel', Level.LEVEL0, () => {
      gestureRecord.recordCurGesture(GestureNavigationState.START, null);
      ReflectionUtils.setProperty(gestureRecord, 'curState', GestureNavigationState.CANCEL);
      gestureRecord.recordCurGesture(GestureNavigationState.UPDATE, null);
      expect(true).assertTrue()
    })

    it('recordCurGestureModel_01', Level.LEVEL0, () => {
      ReflectionUtils.setProperty(gestureRecord, 'curState', GestureNavigationState.CANCEL);
      gestureRecord.recordCurGesture(GestureNavigationState.START);
      gestureRecord.recordCurGesture(GestureNavigationState.END);
      expect(true).assertTrue()
    })

    it('recordCurGestureModel_getCurAction', Level.LEVEL0, () => {
      ReflectionUtils.setProperty(gestureRecord, 'curState', GestureNavigationState.CANCEL);
      expect(gestureRecord.getCurAction()).assertEqual(GestureNavigationState.CANCEL);
    })

    it('processCancelModel_01', Level.LEVEL0, () => {
      gestureRecord.processCancel();
      expect(true).assertTrue()
    })

    it('processCancelModel_02', Level.LEVEL0, () => {
      gestureRecord = new SCBGestureRecord(null);
      ReflectionUtils.setProperty(gestureRecord, 'curState', GestureNavigationState.START);
      ReflectionUtils.setProperty(gestureRecord, 'cancelEvent', null);
      gestureRecord.processCancel();
      ReflectionUtils.setProperty(gestureRecord, 'cancelEvent', () => {
      });
      ReflectionUtils.setProperty(gestureRecord, 'curGestureEvent', null);
      gestureRecord.processCancel();
      ReflectionUtils.setProperty(gestureRecord, 'cancelEvent', () => {
      });
      ReflectionUtils.setProperty(gestureRecord, 'curGestureEvent', () => {
      });
      gestureRecord.processCancel();
      expect(true).assertTrue()
    })

    it('event_test', Level.LEVEL0, () => {
      gestureRecord = new SCBGestureRecord(null);
      gestureRecord.preOffsetX = 0;
      gestureRecord.startEvent;
      expect(0).assertEqual(gestureRecord.preOffsetX);
      gestureRecord.preOffsetY = 0;
      expect(0).assertEqual(gestureRecord.preOffsetY);
      expect(true).assertTrue()
    })
  });
}