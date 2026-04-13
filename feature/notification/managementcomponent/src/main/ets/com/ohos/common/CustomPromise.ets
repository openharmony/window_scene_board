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

type ResolveFn<T> = (value: T | PromiseLike<T>) => void;
type RejectFn = (reason?: Error) => void;

export class CustomPromise<T> extends Promise<T> {
  public resolve: ResolveFn<T>;
  public reject: RejectFn;

  constructor(executor?: (resolve: ResolveFn<T>, reject: RejectFn) => void) {
    let tempResolve: ResolveFn<T> | undefined;
    let tempReject: RejectFn | undefined;
    
    super((resolve, reject) => {
      tempResolve = resolve;
      tempReject = reject;
      executor?.(resolve, reject);
    });

    this.resolve = tempResolve!;
    this.reject = tempReject!;
  }
}