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

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium';
import relationalStore from '@ohos.data.relationalStore';

export function MemoryUtilsTest() {
  describe('MemoryUtilsTest', () => { // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => { // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => { // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => { // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => { // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })

    it('test_getPss', 0, () => {
      expect(MemoryUtils.getPss()).assertInstanceOf('BigInt');
    });

    it('test_getNativeHeapSize', 0, () => {
      expect(MemoryUtils.getNativeHeapSize()).assertInstanceOf('BigInt');
    });

    it('test_isMemoryManagerEnable', 0, () => {
      expect(MemoryUtils.isMemoryManagerEnable()).assertInstanceOf('Boolean');
    });

    it('test_getMemoryMonitorInterval', 0, () => {
      expect(MemoryUtils.getMemoryMonitorInterval()).assertInstanceOf('Number');
    });

    it('test_removeNapiWrap', 0, () => {
      MemoryUtils.removeNapiWrap(new Object(), false);
      MemoryUtils.removeNapiWrap(null, false);
      MemoryUtils.removeNapiWrap(undefined, false);
      expect(true).assertTrue();
    });

    it('MemoryUtilsTest_closeResultSet', 0, () => {
      MemoryUtils.closeResultSet(null);
      let resultSet: relationalStore.ResultSet = new CustomResultSet();
      try {
        MemoryUtils.closeResultSet(resultSet);
      } catch (error) {
      }
      resultSet = new CustomResultSetSub();
      try {
        MemoryUtils.closeResultSet(resultSet);
      } catch (error) {
      }
      expect(true).assertTrue();
    });
  })

  class CustomResultSet implements relationalStore.ResultSet {
    columnNames: string[] = [];
    columnCount: number = 0;
    rowCount: number = 0;
    rowIndex: number = 0;
    isAtFirstRow: boolean = false;
    isAtLastRow: boolean = false;
    isEnded: boolean = false;
    isStarted: boolean = false;
    isClosed: boolean = false;

    getColumnIndex(columnName: string): number {
      throw new Error('Method not implemented.');
    }

    getColumnName(columnIndex: number): string {
      throw new Error('Method not implemented.');
    }

    goTo(offset: number): boolean {
      throw new Error('Method not implemented.');
    }

    goToRow(position: number): boolean {
      throw new Error('Method not implemented.');
    }

    goToFirstRow(): boolean {
      throw new Error('Method not implemented.');
    }

    goToLastRow(): boolean {
      throw new Error('Method not implemented.');
    }

    goToNextRow(): boolean {
      throw new Error('Method not implemented.');
    }

    goToPreviousRow(): boolean {
      throw new Error('Method not implemented.');
    }

    getBlob(columnIndex: number): Uint8Array {
      throw new Error('Method not implemented.');
    }

    getString(columnIndex: number): string {
      throw new Error('Method not implemented.');
    }

    getLong(columnIndex: number): number {
      throw new Error('Method not implemented.');
    }

    getDouble(columnIndex: number): number {
      throw new Error('Method not implemented.');
    }

    getAsset(columnIndex: number): relationalStore.Asset {
      throw new Error('Method not implemented.');
    }

    getAssets(columnIndex: number): relationalStore.Assets {
      throw new Error('Method not implemented.');
    }

    getValue(columnIndex: number): relationalStore.ValueType {
      throw new Error('Method not implemented.');
    }

    getFloat32Array(columnIndex: number): Float32Array {
      throw new Error('Method not implemented.');
    }

    getRow(): relationalStore.ValuesBucket {
      throw new Error('Method not implemented.');
    }

    isColumnNull(columnIndex: number): boolean {
      throw new Error('Method not implemented.');
    }

    close(): void {
    }
  }

  class CustomResultSetSub extends CustomResultSet {
    close(): void {
      throw new Error('dt test error.');
    }
  }
}