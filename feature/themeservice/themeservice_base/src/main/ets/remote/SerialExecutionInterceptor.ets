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
import { CalleeMethodSet, MethodArgs } from './RemoteCallee';
import { Queue } from '@kit.ArkTS';
import { RemoteInterceptor } from './RemoteInterceptor';
import { RemoteReq } from './RemoteReq';
import { RemoteRsp } from './RemoteRsp';
import { TsLog } from '../log/TsLog';

const TAG: string = 'SerialExecutionInterceptor';
const MAX_QUEUE_SIZE = 5;
const EMPTY_QUEUE_SIZE = 0;

class MethodReq {
  public ret: Promise<boolean> | undefined;
  public req: RemoteReq | undefined;
  public executeFunc: Function = (): void => {};
}

const msgQueue: Queue<MethodReq> = new Queue<MethodReq>();

/**
 * 接口调用并发拦截器（调用前拦截），如果当前有正在执行的白名单方法，延迟返回promise
 */
class PreParallelInterceptor implements RemoteInterceptor {
  private readonly methodSet: CalleeMethodSet;

  constructor(methodSet: CalleeMethodSet) {
    this.methodSet = methodSet;
  }

  intercept(_timestamp: number, req: RemoteReq, rsp: RemoteRsp): boolean | Promise<boolean> {
    return preIntercept(this.methodSet, req);
  }
}

/**
 * 接口调用并发拦截器（调用后拦截清理），如果queue里有正在等待的方法，通知返回promise
 */
class PostParallelInterceptor implements RemoteInterceptor {
  private readonly methodSet: CalleeMethodSet;

  constructor(methodSet: CalleeMethodSet) {
    this.methodSet = methodSet;
  }

  intercept(_timestamp: number, req: RemoteReq, rsp: RemoteRsp): boolean | Promise<boolean> {
    return postIntercept(this.methodSet, req);
  }
}

function postIntercept(methodSet: CalleeMethodSet, req: RemoteReq): boolean {
  let methodArg: MethodArgs = methodSet.get(req.method);
  const parallel: boolean = methodArg?.securityPolicy?.parallel ?? true;
  if (!parallel) {
    if (!isRequestInExecutingQueue(req)) {
      TsLog.warning(TAG, `reject method ${req?.method}`);
      return false;
    }
    msgQueue.pop();
    const methodReq: MethodReq = msgQueue.getFirst();
    if (methodReq) {
      TsLog.info(TAG, `Execute next method in queue: ${methodReq.req?.method}`);
      methodReq.executeFunc();
    }
  }
  return false;
}

function isRequestInExecutingQueue(req: RemoteReq): boolean {
  for (const queue of msgQueue) {
    if (queue.req === req) {
      return true;
    }
  }
  return false;
}

function preIntercept(methodSet: CalleeMethodSet, req: RemoteReq): boolean | Promise<boolean> {
  let methodArg: MethodArgs = methodSet.get(req.method);
  const parallel: boolean = methodArg?.securityPolicy?.parallel ?? true;
  if (parallel) {
    return false;
  }
  const methodReq: MethodReq = new MethodReq();
  methodReq.req = req;
  const ret: Promise<boolean> = new Promise((resolver) => {
    if (msgQueue.length === EMPTY_QUEUE_SIZE) {
      resolver(false);
      return;
    }
    if (msgQueue.length >= MAX_QUEUE_SIZE) {
      TsLog.error(TAG, `msgQueue has more than five msg, intercept: ${req?.method}`);
      resolver(true);
      return;
    }
    methodReq.executeFunc = (): void => {
      TsLog.info(TAG, `msgQueue execute method: ${req?.method}`);
      resolver(false);
    };
  });
  TsLog.info(TAG, `preIntercept method: ${req?.method}, queue size: ${msgQueue.length} `);
  methodReq.ret = ret;
  if (msgQueue.length < MAX_QUEUE_SIZE) {
    msgQueue.add(methodReq);
  }
  return methodReq.ret;
}

export function preSerialExecutionInterceptor(methodSet: CalleeMethodSet): RemoteInterceptor {
  return new PreParallelInterceptor(methodSet);
}

export function postSerialExecutionInterceptor(methodSet: CalleeMethodSet): RemoteInterceptor {
  return new PostParallelInterceptor(methodSet);
}