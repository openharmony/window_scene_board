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

import { describe, it, expect } from '@ohos/hypium'
import { proxyDefaultSetter, ProxyTarget, ProxySource } from '../../../../../../main/ets/base/ProxyObject';

class Source {
  num: number = 0;
  str: string = '';
  bool: boolean = true;
  res: Resource = {
    bundleName: '',
    moduleName: '',
    id: 0,
  };
}

class Target extends ProxyTarget {
  get num(): number { return 0; }
  get res(): Resource | undefined { return; }
}

function runCase1(): void {
  const source = new Source();
  const proxySource = new ProxySource(source);
  expect(proxySource.value.num).assertEqual(source.num);
  expect(proxySource.value.str).assertEqual(source.str);
  expect(proxySource.value.bool).assertEqual(source.bool);
  expect(proxySource.value.res).assertEqual(source.res);
}

function runCase2(): void {
  const proxySource = new ProxySource(new Source());
  const target = proxySource.createProxy(new Target, {
    num: proxyDefaultSetter,
    res: proxyDefaultSetter,
  });
  expect(target.num).assertEqual(proxySource.value.num);
  expect(target.res).assertEqual(proxySource.value.res);
}

function runCase3(): void {
  const proxySource = new ProxySource(new Source());
  const target = proxySource.createProxy(new Target, {
    num: proxyDefaultSetter,
    res: (value, obj) => {
      return value?.bundleName === '1'
    }
  });
  proxySource.value.num = 999;
  proxySource.value.res = { bundleName: '1', moduleName: '1', id: 1 };
  expect(target.num).assertEqual(proxySource.value.num);
  expect(target.res).assertEqual(proxySource.value.res);

  // 本地修改应该被拦截，因此被代理对象不应该更新
  proxySource.value.res = { bundleName: '2', moduleName: '2', id: 3 };
  expect(target.res).assertDeepEquals({ bundleName: '1', moduleName: '1', id: 1 });
}

async function runCase4(): Promise<void> {
  const proxySource = new ProxySource(new Source());
  const promise = new Promise<boolean>((resolve, reject) => {
    setTimeout(() => reject(new Error('Timeout for watcher')));
    proxySource.addWatcher(['num', 'str'], () => {
      resolve(proxySource.value.num === 1 && proxySource.value.str === 'sss');
    });
  });
  proxySource.value.num = 1;
  proxySource.value.str = 'sss';
  const result = await promise;
  expect(result).assertEqual(true);

  // 更新字段和监听字段无关，不应该触发
  const promise2 = new Promise<boolean>((resolve, reject) => {
    setTimeout(() => reject(new Error('Timeout for watcher')));
    proxySource.addWatcher(['num', 'str'], () => {
      resolve(proxySource.value.num === 1 && proxySource.value.str === 'sss');
    });
  });
  proxySource.value.bool = !proxySource.value.bool;
  try {
    await promise2;
    throw new Error('Unexpected reach here');
  } catch (e) {
    expect(e.message).assertEqual('Timeout for watcher');
  }
}

export function ProxyObjectTest() {
  describe('ProxyObject', () => {
    it ('should_return_correct_object_when_create_proxy_source', 0, runCase1);
    it('should_return_correct_proxy', 0, runCase2);
    it('target_should_equal_when_update_source', 0, runCase3);
    it('should_trigger_watcher_when_update_source', 0, runCase4);
  });
}